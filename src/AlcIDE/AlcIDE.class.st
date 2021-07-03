Class {
	#name : #AlcIDE,
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
		'miSelectedItem'
	],
	#classInstVars : [
		'horizontalScrollBar'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlcIDE class >> currentApplication [
	^ MiApplication current
]

{ #category : #specs }
AlcIDE class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: #toolbar height: self toolbarHeight;
		  add: (SpPanedLayout newTopToBottom
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newLeftToRight
								     add: #left;
								     add: #middle);
						    add: #right;
						    yourself);
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newLeftToRight
								     add: #downLeft;
								     add: #downMiddle);
						    add: #downRight;
						    yourself));
		  add: #status height: self toolbarHeight
]

{ #category : #specs }
AlcIDE class >> open [ 
	<script> 
	self new openWithSpec 
]

{ #category : #specs }
AlcIDE class >> runMe [
	<script>
	^ self runMeFollowing: self currentApplication defaultBus
]

{ #category : #'instance creation' }
AlcIDE >> allPresenters [

	^ { #left. #middle. #right. #downRight. #downMiddle. #downLeft } 
		  flatCollect: [ :m | (self instVarNamed: m) installedPresenters ]
]

{ #category : #'as yet unclassified' }
AlcIDE >> allPresentersBut: anAlceReferenceWidget [

	^ self allPresenters asOrderedCollection
		  remove: anAlceReferenceWidget ifAbsent: [  ];
		  yourself
]

{ #category : #initialization }
AlcIDE >> application [
	 ^ application
]

{ #category : #'instance creation' }
AlcIDE >> followAction [

	self allPresenters do: [ :p | p followAction ]
]

{ #category : #initialization }
AlcIDE >> initializePresenters [

	super initializePresenters.
	toolbar := self newToolbar.
	status := self newStatusBar.
	left := self newContainer.
	middle := self newContainer.
	right := self newContainer.
	downRight := self newContainer.
	downMiddle := self newContainer.
	downLeft := self newContainer
]

{ #category : #'instance creation' }
AlcIDE >> installTransfer: aTransfer into: destination [

	(destination install: aTransfer passenger)
		dragTilte;
		browser: self;
		whenClose: [ :a | destination hasLeft: a ].
	aTransfer passenger hasBeenReinstalled
]

{ #category : #'instance creation' }
AlcIDE >> miSelectedItem [

	^ miSelectedItem
]

{ #category : #'instance creation' }
AlcIDE >> newContainer [

	^ ((self instantiate: SpDropIn)
		   borderWidth: 2;
		   dropEnabled: true;
		   wantsDrop: [ :transfer :destination | 
			   self shouldAcceptTransfer: transfer into: destination ];
		   acceptDrop: [ :transfer :destination | 
			   self installTransfer: transfer into: destination ]) yourself
]

{ #category : #'instance creation' }
AlcIDE >> propagate: aWidget [

	miSelectedItem := aWidget miSelectedItem.
	miSelectedItem ifNil: [ ^ self ].
	(self allPresentersBut: aWidget) do: [ :w | 
		w selectEntity: miSelectedItem ].

	self propagate.
	miSelectedItem := nil
]

{ #category : #'instance creation' }
AlcIDE >> selectEntity: anEntity [

	self allPresenters do: [ :p | p selectEntity: anEntity ]
]

{ #category : #'instance creation' }
AlcIDE >> shouldAcceptTransfer: aTransfer [

	(aTransfer isKindOf: SpTransferMorph) ifFalse: [ ^ false ].
	^ aTransfer passenger canBeAdaptedToAlcIDE
]

{ #category : #'instance creation' }
AlcIDE >> shouldAcceptTransfer: aTransfer into: aDestination [

	(aTransfer isKindOf: SpTransferMorph) ifFalse: [ ^ false ].
	^ aTransfer passenger canBeAdaptedToDropInto: aDestination
]