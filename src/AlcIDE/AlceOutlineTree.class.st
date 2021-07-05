Class {
	#name : #AlceOutlineTree,
	#superclass : #AlceAbstractWidget,
	#instVars : [
		'tree'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceOutlineTree class >> defaultSpec [

	^ super defaultSpec
		  add: #tree;
		  yourself
]

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
		children addAll: anEntry globalVariables.
		children addAll: anEntry members.
		children addAll: anEntry invocables ].
	(anEntry isKindOf: AlcixEnum) ifTrue: [ 
		children addAll: anEntry enumValues ].

	(anEntry isKindOf: AlcixInvocable) ifTrue: [ 
		children addAll: anEntry parameters.
		children addAll:
			(anEntry localVariables reject: [ :v | v name = anEntry selector ]) ].


	^ children
]

{ #category : #visiting }
AlceOutlineTree >> followAction [

	tree items: (self childrenFor: toSelect)
]

{ #category : #visiting }
AlceOutlineTree >> iconFor: anEntry [

	^ (anEntry isKindOf: Association)
		  ifTrue: [ MiAlceIdeIcons iconForEntryName: anEntry key ]
		  ifFalse: [ MiAlceIdeIcons iconFor: anEntry ]
]

{ #category : #visiting }
AlceOutlineTree >> imageRepresentationFor: each [

	^ each name asStringMorph backgroundColor: (self colorForTable: each)
]

{ #category : #visiting }
AlceOutlineTree >> initializePresenters [

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
