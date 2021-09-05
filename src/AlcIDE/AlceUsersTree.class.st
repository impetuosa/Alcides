Class {
	#name : #AlceUsersTree,
	#superclass : #AlceTreeWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #accessing }
AlceUsersTree class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alceProjectBrowser)
		parent: self alceBrowsers;
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #accessing }
AlceUsersTree class >> runMe [
	<script>
	super runMe
]

{ #category : #accessing }
AlceUsersTree class >> title [

	^ 'Users Browser'
]

{ #category : #initialization }
AlceUsersTree >> accept: aModel [

	^ { 
		  AlcixInvocable.
		  AlcixAccessible } anySatisfy: [ :c | aModel isKindOf: c ]
]

{ #category : #initialization }
AlceUsersTree >> childrenFor: anEntry [

	| children temp |
	children := OrderedCollection new.
	(anEntry isKindOf: AlcixInvocable) ifTrue: [ 
		temp := ((anEntry incomingAccesses collect: [ :e | e sender ]) 
			         sort: [ :e | e selector ] ascending) groupedBy: [ :i | 
			        i userType ].
		temp ifNotEmpty: [ children add: #Invocations -> temp ].
		^ children ].

	(anEntry isKindOf: AlcixAccessible) ifTrue: [ 
		temp := (anEntry incomingAccesses collect: [ :r | r invocable ]) 
			        sort: #selector ascending.
		temp ifNotEmpty: [ children add: #Read -> temp ].
		"temp := (anEntry assignments collect: [ :r | r invocable ]) 
			        sort: #selector ascending.
		temp ifNotEmpty: [ children add: #Write -> temp ] "].

	anEntry isAssociation ifTrue: [ 
		anEntry value isDictionary
			ifTrue: [ children addAll: anEntry value associations ]
			ifFalse: [ children addAll: anEntry value ] ].

	(children anySatisfy: [ :a | a isKindOf: AlcixInvocation ]) ifTrue: [ 
		 ].
	^ children removeDuplicates
]

{ #category : #initialization }
AlceUsersTree >> followAction [

	tree items: (self childrenFor: toSelect)
]

{ #category : #initialization }
AlceUsersTree >> iconFor: anEntry [

	anEntry isAssociation ifTrue: [ 
		anEntry key = #Write ifTrue: [ ^ self iconNamed: #edit ].
		anEntry key = #Read ifTrue: [ ^ self iconNamed: #haloView ].
		anEntry key = #Invocations ifTrue: [ 
			^ self iconNamed: #glamorousInto ].
		^ super iconFor: anEntry key ].

	^ super iconFor: anEntry
]

{ #category : #initialization }
AlceUsersTree >> selection: aSelection [

	| item |
	item := self getSelectedItem: aSelection.

	(item isNotNil and: [ (item isKindOf: Association) not ]) ifTrue: [ 
		super selection: item ].
	super selection: aSelection
]
