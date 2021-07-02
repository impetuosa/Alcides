Class {
	#name : #AlcIDE,
	#superclass : #SpPresenter,
	#instVars : [
		'toolbar',
		'status',
		'down',
		'left',
		'middle',
		'right'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlcIDE class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: #toolbar height: self toolbarHeight;
		  add: (SpBoxLayout newLeftToRight
				   add: #left width: 200;
				   add: #middle;
				   add: #right width: 200;
				   yourself);
		  add: #down; 
		  add: #status height: self toolbarHeight
]

{ #category : #specs }
AlcIDE class >> open [ 
	<script> 
	self new openWithSpec 
]

{ #category : #initialization }
AlcIDE >> initializePresenters [

	super initializePresenters.
	toolbar := self newToolbar.
	status := self newStatusBar.
	left := self newContainer.
	middle := self newContainer.
	right := self newContainer.
	down := self newContainer
]

{ #category : #'instance creation' }
AlcIDE >> installTransfer: aTransfer [ 
	self haltOnce.
	^ false. 
]

{ #category : #'instance creation' }
AlcIDE >> newContainer [

	^ ((self instantiate: SpDragHere)
		   dropEnabled: true;
		   wantsDrop: [ :transfer | self shouldAcceptTransfer: transfer ];
		   acceptDrop: [ :transfer | self installTransfer: transfer ])
		  yourself
]

{ #category : #'instance creation' }
AlcIDE >> shouldAcceptTransfer: aTransfer [ 
	self haltOnce.
	^ false. 
]
