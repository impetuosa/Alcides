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
	super runMe
]

{ #category : #specs }
AlceOutlineTree class >> title [

	^ 'Outline Tree Browser'
]

{ #category : #visiting }
AlceOutlineTree >> accept: aModel [

	^ { 
		  AlcixEnum.
		  AlcixModule.
		  AlcixDataSource } anySatisfy: [ :c | aModel isKindOf: c ]
]

{ #category : #visiting }
AlceOutlineTree >> childrenFor: anEntry [

	| children |
	children := OrderedCollection new.
	(anEntry isKindOf: AlcixModule) ifTrue: [ 
		children addAll: (anEntry globalVariables sort: #name ascending).
		children addAll: (anEntry members sort: #name ascending).
		children addAll: (anEntry invocables sort: #name ascending) ].
	(anEntry isKindOf: AlcixEnum) ifTrue: [ 
		children addAll: anEntry enumValues ].

	(anEntry isKindOf: AlcixInvocable) ifTrue: [ 
		children addAll: (anEntry parameters sort: #name ascending).
		children addAll:
			((anEntry localVariables reject: [ :v | v name = anEntry selector ]) 
				 sort: #name ascending) ].


	^ children removeDuplicates
]

{ #category : #visiting }
AlceOutlineTree >> followAction [

	tree items: (self childrenFor: toSelect)
]
