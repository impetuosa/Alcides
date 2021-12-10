Class {
	#name : #AlceReferenceWidget,
	#superclass : #AlceDraggableWidget,
	#instVars : [
		'viewport',
		'tables'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceReferenceWidget class >> defaultSpec [
	^ super defaultSpec
		add: #viewport;
		yourself
]

{ #category : #specs }
AlceReferenceWidget class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alceReferenceBrowser)
		parent:  AlcIDE alceBrowsers;
		label: (self title);
		icon: (self iconNamed: #mooseTree); 
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceReferenceWidget class >> runMe [

	<script>
	^ super runMe
]

{ #category : #accessing }
AlceReferenceWidget class >> title [

	^ 'Alce Reference Browser'
]

{ #category : #actions }
AlceReferenceWidget >> accept: aModel [

	(aModel class respondsTo: #entryName) ifTrue: [ 
		tables at: aModel class entryName ifPresent: [ :t | 
			(t items includes: aModel) ifTrue: [ 
				viewport pages
					detect: [ :p | p presenterProvider = t ]
					ifFound: [ :p | viewport selectPage: p ].
				t selectItem: aModel ] ] ].
	^ aModel isKindOf: AlcixReference
]

{ #category : #actions }
AlceReferenceWidget >> cleanup [ 
	viewport removeAll.
	tables valuesDo: [ : v |  v  items: {  } ]
]

{ #category : #actions }
AlceReferenceWidget >> followAction [
	self cleanup.
	((toSelect types , toSelect members) asSet groupedBy: #class) 
		associationsDo: [ :group | 
			(self tableNamed: group key entryName) items:
				group value asOrderedCollection ].
	viewport selectPage: viewport pages first
]

{ #category : #initialization }
AlceReferenceWidget >> initializePresenters [

	super initializePresenters.
	viewport := self newNotebook .
	tables := Dictionary new
]

{ #category : #actions }
AlceReferenceWidget >> tableNamed: aTableName [

	| table |
	table := tables at: aTableName ifAbsentPut: [ 
		         | instance |
		         instance := self newTable
			                     contextMenu: [ 
				                     self rootCommandsGroup asMenuPresenter ];
			                     whenSelectionChangedDo: [ :sel | 
				                     self selection: sel ];
			                     addColumn: (SpIndexTableColumn new
					                      title: 'Index';
					                      sortFunction: #yourself ascending;
					                      beNotExpandable;
					                      width: 20;
					                      yourself);
			                     addColumn:
				                     ((SpImageTableColumn evaluated: [ :each | 
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
			                     addColumn: (SpStringTableColumn new
					                      title: 'ASTLoad';
					                      evaluated: [ :each | each isAstLoaded ];
					                      sortFunction:
						                      [ :each | each isAstLoaded asString ]
							                      ascending;
												width: 40;
					                      beExpandable;
					                      yourself);
			                     addColumn:
				                     ((SpImageTableColumn evaluated: [ :each | 
						                       (Morph new color: (self colorForTable: each)) asForm ])
					                      width: 10;
					                      sortFunction: #className ascending;
					                      yourself) ].

	viewport addPage: ((SpNotebookPage
			  title: aTableName
			  icon: (self iconNamed: #nautilusIcon)
			  provider: table)
			 beCloseable;
			 yourself).

	^ table
]
