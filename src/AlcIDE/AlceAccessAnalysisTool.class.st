Class {
	#name : #AlceAccessAnalysisTool,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'status',
		'left',
		'middle',
		'right',
		'downRight',
		'downMiddle',
		'downLeft',
		'miSelectedItem',
		'viewport',
		'tools',
		'projectTree',
		'newPerspectiveButton',
		'perspectives',
		'perspectivesDictionary',
		'lastPropagatingSelection',
		'lastPropagatingWidget'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceAccessAnalysisTool class >> alceBrowsers [

	^ 'Alce browsers'
]

{ #category : #specs }
AlceAccessAnalysisTool class >> currentApplication [
	^ MiApplication current
]

{ #category : #specs }
AlceAccessAnalysisTool class >> defaultSpec [

	^ SpBoxLayout newLeftToRight
		  add: (SpBoxLayout newTopToBottom
				   add: #tools height: 435;
				   add: #perspectives;
				   yourself)
		  width: 80;
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 20 percent;
				   add: #projectTree;
				   add: #viewport);
		  yourself
]

{ #category : #specs }
AlceAccessAnalysisTool class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alceIdeBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		icon: (AlcIDE iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #specs }
AlceAccessAnalysisTool class >> midasBrowserMenuLabel [
	^ #'Specialized Browsers'
]

{ #category : #specs }
AlceAccessAnalysisTool class >> open [

	<script>
	self new
		followBus: self currentApplication defaultBus;
		open
]

{ #category : #specs }
AlceAccessAnalysisTool class >> runMe [

	^ self open
]

{ #category : #specs }
AlceAccessAnalysisTool class >> runMeFollowing: aBus [
]

{ #category : #specs }
AlceAccessAnalysisTool class >> title [ 
	 ^ 'Alce | Access Analysis Tool'
]

{ #category : #initialization }
AlceAccessAnalysisTool >> addPerspective [

	| name |
	name := UIManager default
		        request: 'Please enter a name for the perspective'
		        initialAnswer: 'Default'.
	name ifNil: [ ^ self ].
	^ self addPerspectiveNamed: name
]

{ #category : #initialization }
AlceAccessAnalysisTool >> addPerspectiveNamed: name [

	| label |
	label := self instantiate: AlceLabelEntry.
	label label: name.
	perspectivesDictionary at: label put: self newContainer.
	perspectives addPresenter: label.
	perspectives selectItem: label
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> allPresenters [

	^ viewport installedPresenters , { projectTree }
]

{ #category : #'as yet unclassified' }
AlceAccessAnalysisTool >> allPresentersBut: anAlceReferenceWidget [

	^ self allPresenters asOrderedCollection
		  remove: anAlceReferenceWidget ifAbsent: [  ];
		  yourself
]

{ #category : #initialization }
AlceAccessAnalysisTool >> application [
	 ^ application
]

{ #category : #testing }
AlceAccessAnalysisTool >> canFollowEntity: anUndefinedObject [ 
	^ true
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> followAction [
	self allPresenters do: [ :p | p followAction ]
]

{ #category : #initialization }
AlceAccessAnalysisTool >> initializePresenters [

	super initializePresenters.
	perspectivesDictionary := Dictionary new.
	tools := self instantiate: AlceButtonListMenu.

	newPerspectiveButton := tools newPopoverButton.
	newPerspectiveButton
		icon: (self iconNamed: #book);
		help: 'Perspectives';
		yourself.

	newPerspectiveButton actions: { 
			(AlceAction new
				 name: 'Add';
				 action: [ self addPerspective ]).

			(AlceAction new
				 name: 'Remove';
				 action: [ self removePerspective ]).

			(AlceAction new
				 name: 'Rename';
				 action: [ self renamePerspective ]) }.
	projectTree := self instantiate: AlceProjectTree.
	projectTree browser: self.
	projectTree dragTilte.

	perspectives := self newComponentList.
	perspectives whenSelectionChangedDo: [ :s | 
		self setViewportTo: s selectedItem ].

	viewport := self newLabel label: ' Select a Perspective please'.
	self addPerspectiveNamed: #Default
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> installTransfer: aTransfer into: destination [

	(destination install: aTransfer passenger)
		dragTilte;
		browser: self;
		whenClose: [ :a | destination noteThatWidgetHasBeenClosed:  a ].
	aTransfer passenger hasBeenReinstalled
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> miSelectedItem [

	^ miSelectedItem
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> newContainer [

	| container |
	container := ((self instantiate: SpDropInPanedContainer)
		              beMultiple;
						  beLeftPaned;
		              borderWidth: 2;
		              dropEnabled: true;
		              wantsDrop: [ :transfer :destination | 
			              self shouldAcceptTransfer: transfer into: destination ];
		              acceptDrop: [ :transfer :destination | 
			              self installTransfer: transfer into: destination ])
		             yourself.
	container left beLeftToRight.
	container right beLeftToRight.
	^ container
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> propagate: aWidget [

	| selecting |

	selecting := aWidget miSelectedItem.
	selecting ifNil: [ ^ self ].
	(self allPresentersBut: aWidget) do: [ :w | 
		w selectEntity: selecting.
		miSelectedItem := selecting ].
	miSelectedItem := selecting.
	aWidget = projectTree ifTrue: [ 
		lastPropagatingSelection := selecting.
		lastPropagatingWidget := aWidget ].
	miSelectedItem := selecting.
	self propagate.
	miSelectedItem := nil
]

{ #category : #initialization }
AlceAccessAnalysisTool >> removePerspective [

	perspectivesDictionary removeKey: perspectives selectedItem ifAbsent: [].
	perspectives presenters:
		(perspectives presenters reject: [ :a | 
			 a = perspectives selectedItem ])
]

{ #category : #initialization }
AlceAccessAnalysisTool >> renamePerspective [

	| newName |
	newName := UIManager default
		           request: 'Please enter a new name'
		           initialAnswer: perspectives selectedItem label.
	newName ifNotNil: [ perspectives selectedItem label: newName ]
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> repropagateLast [

	lastPropagatingSelection ifNil: [ ^ self ].
	miSelectedItem := lastPropagatingSelection.
	(self allPresentersBut: lastPropagatingWidget) do: [ :w | 
		w selectEntity: lastPropagatingSelection.
		miSelectedItem := lastPropagatingSelection ].

	miSelectedItem := nil
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> selectEntity: anEntity [

	self allPresenters do: [ :p | p selectEntity: anEntity ]
]

{ #category : #initialization }
AlceAccessAnalysisTool >> setViewportTo: aSpLabelPresenter [
	| next | 
	next := perspectivesDictionary at: aSpLabelPresenter.
	next = viewport ifTrue: [ ^ self  ].
	viewport := next. 
	self update.
	self repropagateLast 
]

{ #category : #'instance creation' }
AlceAccessAnalysisTool >> shouldAcceptTransfer: aTransfer into: aDestination [

	(aTransfer isKindOf: SpTransferMorph) ifFalse: [ ^ false ].
	^ aTransfer passenger canBeAdaptedToDropInto: aDestination
]
