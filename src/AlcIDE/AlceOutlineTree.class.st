Class {
	#name : #AlceOutlineTree,
	#superclass : #AlceTreeWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceOutlineTree class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alceOutlineBrowser)
		parent: self alceBrowsers;
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ] 
]

{ #category : #specs }
AlceOutlineTree class >> runMe [
	<script>
	^ super runMe
]

{ #category : #specs }
AlceOutlineTree class >> title [

	^ 'Outline Tree Browser'
]

{ #category : #visiting }
AlceOutlineTree >> anchorsorter [

	^ [ :a :b | 
	(  a anchor isNil or: [ b anchor isNil ])
		  ifTrue: [ a printString threeWayCompareTo: b  printString]
		  ifFalse: [ a anchor srcFrom threeWayCompareTo: b anchor srcFrom ] ]
		  ascending
]

{ #category : #visiting }
AlceOutlineTree >> canFollowEntity: aModel [

	^ { 
		  AlcixEnum.
		  AlcixModule.
		  AlcixDataSource.
		  AlcixUserType } anySatisfy: [ :c | aModel isKindOf: c ]
]

{ #category : #visiting }
AlceOutlineTree >> childrenFor: anEntry [

	| children |
	children := OrderedCollection new.

	(anEntry isKindOf: AlcixUserType) ifTrue: [ 
		children addAll: anEntry members.
		(anEntry isKindOf: AlcixModule) ifTrue: [ 
			children addAll: anEntry constants.
			children addAll: anEntry globalVariables.
			children addAll: anEntry invocables ] ].
	(anEntry isKindOf: AlcixEnum) ifTrue: [ 
		children addAll: anEntry enumValues ].

	(anEntry isKindOf: AlcixInvocable) ifTrue: [ 
		children addAll: anEntry parameters.
		children addAll:
			(anEntry localVariables reject: [ :v | v name = anEntry selector ]).

		children addAll: anEntry outgoingAccesses.
		children addAll: anEntry assignments.
		children addAll: anEntry returns ].


	^ children removeDuplicates sort: self anchorsorter
]

{ #category : #visiting }
AlceOutlineTree >> followAction [

	tree items: (self childrenFor: toSelect)
]
