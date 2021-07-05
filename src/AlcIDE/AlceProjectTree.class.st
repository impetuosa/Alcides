Class {
	#name : #AlceProjectTree,
	#superclass : #AlceAbstractWidget,
	#instVars : [
		'tree'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceProjectTree class >> defaultSpec [

	^ super defaultSpec
		  add: #tree;
		  yourself
]

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
				children addAll: anEntry types ] ].
	(anEntry isKindOf: Association) ifTrue: [ 
		children addAll: anEntry value ].
	^ children
]

{ #category : #visiting }
AlceProjectTree >> colorForTable: each [

	^ (each isKindOf: Association)
		  ifTrue: [ Color transparent ]
		  ifFalse: [ super colorForTable: each ]
]

{ #category : #visiting }
AlceProjectTree >> followAction [

	tree items: toSelect references
]

{ #category : #visiting }
AlceProjectTree >> iconFor: anEntry [

	^ (anEntry isKindOf: Association)
		  ifTrue: [ MiAlceIdeIcons iconForEntryName: anEntry key ]
		  ifFalse: [ MiAlceIdeIcons iconFor: anEntry ]
]

{ #category : #visiting }
AlceProjectTree >> imageRepresentationFor: each [

	^ each name asStringMorph backgroundColor: (self colorForTable: each)
]

{ #category : #visiting }
AlceProjectTree >> initializePresenters [

	super initializePresenters.

	tree := self newTreeTable.
	tree
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		whenSelectionChangedDo: [ :e | self selection: e ].
	tree
		addColumn: (SpCompositeTableColumn new
				 title: '';
				 addColumn:
					 ((SpImageTableColumn evaluated: [ :each | self iconFor: each ])
						  width: 20;
						  yourself);
				 addColumn: (SpImageTableColumn evaluated: [ :each | 
						  self imageRepresentationFor: each ]);
				 yourself);
		children: [ :entry | self childrenFor: entry ]
]
