Class {
	#name : #AlceTreeWidget,
	#superclass : #AlceDraggableWidget,
	#instVars : [
		'tree'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceTreeWidget class >> alceBrowsers [

	^ 'Alce browsers'
]

{ #category : #specs }
AlceTreeWidget class >> defaultSpec [

	^ super defaultSpec
		  add: #tree;
		  yourself
]

{ #category : #specs }
AlceTreeWidget class >> isAbstract [

	^ self = AlceTreeWidget
]

{ #category : #initialization }
AlceTreeWidget >> childrenFor: anEntry [

	self subclassResponsibility
]

{ #category : #accessing }
AlceTreeWidget >> colorForTable: each [

	^ (each isKindOf: Association)
		  ifTrue: [ Color transparent ]
		  ifFalse: [ super colorForTable: each ]
]

{ #category : #defaults }
AlceTreeWidget >> iconFor: anEntry [

	^ (anEntry isKindOf: Association)
		  ifTrue: [ MiAlceIdeIcons iconForEntryName: anEntry key ]
		  ifFalse: [ MiAlceIdeIcons iconFor: anEntry ]
]

{ #category : #visiting }
AlceTreeWidget >> imageRepresentationFor: each [
	^ (AlceElementToString new toString: each) asStringMorph 
		  backgroundColor: (self colorForTable: each)
]

{ #category : #initialization }
AlceTreeWidget >> initializePresenters [

	super initializePresenters.

	tree := self newTreeTable.
	tree beMultipleSelection.
	tree
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		whenSelectionChangedDo: [ :e | 
			self selection: e ].
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

{ #category : #visiting }
AlceTreeWidget >> selection: aSelection [

	| item |
	item := self getSelectedItem: aSelection.

	(item respondsTo: #anchor) ifTrue: [ super selection: item anchor ].
	super selection: aSelection
]
