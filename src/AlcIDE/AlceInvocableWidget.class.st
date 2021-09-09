Class {
	#name : #AlceInvocableWidget,
	#superclass : #MiDraggableAbstractWidget,
	#instVars : [
		'readings',
		'writings',
		'incoming',
		'outgoing',
		'readingsTitle',
		'writingsTitle',
		'incomingsTitle',
		'outgoingsTitle'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceInvocableWidget class >> alceBrowsers [

	^ 'Alce browsers'
]

{ #category : #specs }
AlceInvocableWidget class >> defaultSpec [

	^ super defaultSpec
		  add: #readingsTitle height: 20;
		  add: #readings;
		  add: #writingsTitle height: 20;
		  add: #writings;
		  add: #incomingsTitle height: 20;
		  add: #incoming;
		  add: #outgoingsTitle height: 20;
		  add: #outgoing
]

{ #category : #specs }
AlceInvocableWidget class >> menuCommandOn: aBuilder [
	<worldMenu> 
	<miBrowsers>
	(aBuilder item: #alceInvocableBrowser) 
		parent: self alceBrowsers;
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceInvocableWidget class >> runMe [
	<script>
	super runMe
]

{ #category : #specs }
AlceInvocableWidget class >> title [

	^ 'Alce Invocable Browser'
]

{ #category : #visiting }
AlceInvocableWidget >> accept: aModel [

	^ aModel isKindOf: AlcixInvocable
]

{ #category : #visiting }
AlceInvocableWidget >> followAction [

	incoming items: toSelect incomingInvocations asOrderedCollection.
	outgoing items: toSelect outgoingInvocations asOrderedCollection.
	writings items:
		(toSelect accesses asOrderedCollection select:[ :e | e  isWriting and: [ e isReturn not ] ]).
	readings items:
		(toSelect accesses asOrderedCollection reject: #isWriting)
]

{ #category : #visiting }
AlceInvocableWidget >> initializePresenters [

	super initializePresenters.
	readings := self newReadingsTable.
	writings := self newWritingsTable.
	incoming := self newIncomingTable. 
	outgoing := self newOutgoingTable.

	readingsTitle := self newLabel
		                 label: 'Variable Read from this function';
		                 yourself.

	writingsTitle := self newLabel
		                 label: 'Variable Writen from this function';
		                 yourself.

	incomingsTitle := self newLabel
		                  label: 'Functions calling this function';
		                  yourself.

	outgoingsTitle := self newLabel
		                  label: 'Functions called by this function';
		                  yourself
]

{ #category : #visiting }
AlceInvocableWidget >> newIncomingTable [

	^ self newTable
		  contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		  whenSelectionChangedDo: [ :e | self selection: e ];
		  addColumn: (SpIndexTableColumn new
				   title: 'Index';
				   sortFunction: #yourself ascending;
				   beNotExpandable;
				   width: 20;
				   yourself);
		  addColumn: ((SpImageTableColumn new
				    title: 'Resolved';
				    evaluated: [ :each | 
					    each candidate
						    ifNil: [ self iconNamed: #smallQuestion ]
						    ifNotNil: [ self iconNamed: #glamorousAccept ] ])
				   width: 10;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Selector';
				   evaluated: [ :each | each selector ];
				   sortFunction: #printString ascending;
				   beExpandable;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: '#Arguments';
				   evaluated: [ :each | each arguments size ];
				   beExpandable;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    (Morph new color: (self colorForTable: each)) asForm ])
				   width: 10;
				   yourself);
		  yourself
]

{ #category : #visiting }
AlceInvocableWidget >> newOutgoingTable [

	^ self newIncomingTable
]

{ #category : #visiting }
AlceInvocableWidget >> newReadingsTable [

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
					    each candidate
						    ifNil: [ self iconNamed: #smallQuestion ]
						    ifNotNil: [ self iconNamed: #glamorousAccept ] ])
				   width: 10;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Reading entity';
				   evaluated: [ :each | 
					   each candidate name
						   ifNil: [ 'Un analyzed expression' ]
						   ifNotNil: [ 
							   each candidate name adaptToAlceAnchorPathFragment ] ];
				   sortFunction: [ :each | 
					   each candidate name
						   ifNil: [ 'Un analyzed expression' ]
						   ifNotNil: [ 
							   each candidate name adaptToAlceAnchorPathFragment ] ]
						   ascending;
				   beExpandable;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    (Morph new color:  (self colorForTable: each)) asForm ])
				   width: 10;
				   yourself);
		  yourself
]

{ #category : #visiting }
AlceInvocableWidget >> newWritingsTable [

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
				    title: 'Resolved(L)';
				    evaluated: [ :each | 
					    each leftElement
						    ifNil: [ self iconNamed: #smallQuestion ]
						    ifNotNil: [ self iconNamed: #glamorousAccept ] ])
				   width: 10;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Storing entity';
				   evaluated: [ :each | 
					   each leftElementName
						   ifNil: [ 'Un analyzed expression' ]
						   ifNotNil: [ 
							   each leftElementName adaptToAlceAnchorPathFragment ] ];
				   sortFunction: [ :each | 
					   each leftElementName
						   ifNil: [ 'Un analyzed expression' ]
						   ifNotNil: [ 
							   each leftElementName adaptToAlceAnchorPathFragment ] ]
						   ascending;
				   beExpandable;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    (Morph new color:  (self colorForTable: each)) asForm ])
				   width: 10;
				   yourself);
		  addColumn: ((SpImageTableColumn new
				    title: 'Resolved(R)';
				    evaluated: [ :each | 
					    each candidate
						    ifNil: [ self iconNamed: #smallQuestion ]
						    ifNotNil: [ self iconNamed: #glamorousAccept ] ])
				   width: 10;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Reading entity';
				   evaluated: [ :each | 
					   each candidate name
						   ifNil: [ 'Un analyzed expression' ]
						   ifNotNil: [ 
							   each candidate name adaptToAlceAnchorPathFragment ] ];
				   sortFunction: [ :each | 
					   each candidate name
						   ifNil: [ 'Un analyzed expression' ]
						   ifNotNil: [ 
							   each candidate name adaptToAlceAnchorPathFragment ] ]
						   ascending;
				   beExpandable;
				   yourself);
		  addColumn: ((SpImageTableColumn evaluated: [ :each | 
					    (Morph new color:  (self colorForTable: each)) asForm ])
				   width: 10;
				   yourself);
		  yourself
]
