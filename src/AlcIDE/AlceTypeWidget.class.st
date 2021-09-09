Class {
	#name : #AlceTypeWidget,
	#superclass : #MiDraggableAbstractWidget,
	#instVars : [
		'typesTable',
		'membersTable',
		'invocableTable',
		'parametersTable'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceTypeWidget class >> alceBrowsers [

	^ 'Alce browsers'
]

{ #category : #specs }
AlceTypeWidget class >> defaultSpec [

	^ super defaultSpec
		  add: #membersTable;
		  add: (SpBoxLayout newHorizontal
				   add: #invocableTable;
				   add: #parametersTable;
				   yourself);
		  add: #typesTable;
		  yourself
]

{ #category : #specs }
AlceTypeWidget class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alceTypeBrowser)
		parent: self alceBrowsers; 
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceTypeWidget class >> runMe [
	<script>
	super runMe
]

{ #category : #specs }
AlceTypeWidget class >> title [

	^ 'Alce Type Browser'
]

{ #category : #visiting }
AlceTypeWidget >> accept: aModel [

	^ { 
		  AlcixEnum.
		  AlcixUserType.
		  AlcixAlias } anySatisfy: [ :a | aModel isKindOf: a ]
]

{ #category : #visiting }
AlceTypeWidget >> followAction [
	typesTable items: toSelect types asSet asOrderedCollection.
	invocableTable items: toSelect invocables asSet asOrderedCollection.
	membersTable items: toSelect members asSet asOrderedCollection.
	parametersTable items: {  }
]

{ #category : #visiting }
AlceTypeWidget >> initializePresenters [

	super initializePresenters.
	typesTable := self newTypesTable. 
	invocableTable := self newInvocablesTable.
	parametersTable := self newMembersTable.
	membersTable := self newMembersTable. 
]

{ #category : #visiting }
AlceTypeWidget >> newInvocablesTable [

	"Smalltalk ui icons"

	^ self newTable
		  contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		  whenSelectionChangedDo: [ :e | 
			  self selectParameters: e selectedItem.
			  self selection: e ];
		  addColumn: (SpIndexTableColumn new
				   title: 'Index';
				   sortFunction: #yourself ascending;
				   beNotExpandable;
				   width: 20;
				   yourself);
		  addColumn: ((SpImageTableColumn new
				    title: 'Resolved';
				    evaluated: [ :each | 
					    (each isKindOf: AlcixFunction)
						    ifFalse: [ self iconNamed: #uncommentedClass ]
						    ifTrue: [ 
							    each type
								    ifNil: [ self iconNamed: #smallQuestion ]
								    ifNotNil: [ self iconNamed: #glamorousAccept ] ] ])
				   width: 10;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Type';
				   evaluated: [ :each | 
					   (each isKindOf: AlcixFunction)
						   ifFalse: [ 'void' ]
						   ifTrue: [ 
							   each type name
								   ifNil: [ 'Unknown' ]
								   ifNotNil: [ :ref | ref adaptToAlceAnchorPathFragment ] ] ];
				   sortFunction: #printString ascending;
				   beExpandable;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Selector';
				   evaluated: [ :each | each selector ];
				   sortFunction: #printString ascending;
				   beExpandable;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: '#Parameters';
				   evaluated: [ :each | each parameters size ];
				   beExpandable;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    (Morph new color:  (self colorForTable: each)) asForm ])
				   width: 10;
				   yourself);
		  yourself
]

{ #category : #visiting }
AlceTypeWidget >> newMembersTable [

	"Smalltalk ui icons"

	^ self newTable
		  contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		  whenSelectionChangedDo: [ :e | self selection: e ];
		  whenActivatedDo: [ :entry | 
			  self selection: entry.
			  self propagate ];
		  addColumn: (SpIndexTableColumn new
				   title: 'Index';
				   sortFunction: #yourself ascending;
				   beNotExpandable;
				   width: 20;
				   yourself);
		  addColumn: ((SpImageTableColumn new
				    title: 'Resolved';
				    evaluated: [ :each | 
					    each type
						    ifNil: [ self iconNamed: #smallQuestion ]
						    ifNotNil: [ self iconNamed: #glamorousAccept ] ])
				   width: 10;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Type';
				   evaluated: [ :each | each typeName ];
				   sortFunction: #printString ascending;
				   beExpandable;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   evaluated: [ :each | each name ];
				   sortFunction: #printString ascending;
				   beExpandable;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    (Morph new color: (self colorForTable: each)) asForm ])
				   width: 10;
				   yourself);
		  yourself
]

{ #category : #visiting }
AlceTypeWidget >> newTypesTable [

	^ self newTable
		  contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		  whenSelectionChangedDo: [ :e | self selection: e ];
		  whenActivatedDo: [ :entry | 
			  self selection: entry.
			  self propagate ];
		  addColumn: (SpIndexTableColumn new
				   title: 'Index';
				   sortFunction: #yourself ascending;
				   beNotExpandable;
				   width: 20;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    self iconFor: each ])
				   width: 10;
				   sortFunction: #className ascending;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   evaluated: [ :each | each name ];
				   sortFunction: #printString ascending;
				   beExpandable;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    (Morph new color: (self colorForTable: each)) asForm ])
				   width: 10;
				   yourself) yourself
]

{ #category : #visiting }
AlceTypeWidget >> selectParameters [

	selection ifNotNil: [ 
		parametersTable items: selection parameters asOrderedCollection ]
]

{ #category : #visiting }
AlceTypeWidget >> selectParameters: item [ 
	
	item ifNotNil: [ 
		parametersTable items: item parameters asOrderedCollection ]
]
