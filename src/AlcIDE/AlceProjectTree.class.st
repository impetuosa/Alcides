Class {
	#name : #AlceProjectTree,
	#superclass : #AlceTreeWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceProjectTree class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alceProjectBrowser)
		parent: self alceBrowsers;
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceProjectTree class >> runMe [
	<script>
	super runMe
]

{ #category : #specs }
AlceProjectTree class >> title [

	^ 'Project Tree Browser'
]

{ #category : #visiting }
AlceProjectTree >> accept: aModel [ 
	^ aModel isKindOf: AlcixModel
]

{ #category : #visiting }
AlceProjectTree >> childrenFor: anEntry [

	| children |
	children := OrderedCollection new.
	(anEntry isKindOf: AlcixReference)
		ifTrue: [ 
			children addAll:
				(anEntry types groupedBy: [ :t | t class entryName ]) associations ]
		ifFalse: [ 
			(anEntry isKindOf: AlcixContainer) ifTrue: [ 
				children addAll: (anEntry types sort: #name ascending) ] ].
	anEntry isAssociation ifTrue: [ 
		children addAll: (anEntry value sort: #name ascending) ].
	^ children removeDuplicates
]

{ #category : #visiting }
AlceProjectTree >> followAction [

	tree items: toSelect references
]
