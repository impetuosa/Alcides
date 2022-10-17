Class {
	#name : #AlcePopOverMenuButton,
	#superclass : #SpPresenter,
	#instVars : [
		'button',
		'popover',
		'actions'
	],
	#category : #'AlcIDE-Menu'
}

{ #category : #layout }
AlcePopOverMenuButton class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #button width: 75;
				   yourself)
		  height: 60
]

{ #category : #specs }
AlcePopOverMenuButton class >> open [ 	
	<script> 
	self new openWithSpec 
]

{ #category : #initialization }
AlcePopOverMenuButton >> actions: aSetOfActions [

	actions := aSetOfActions
]

{ #category : #initialization }
AlcePopOverMenuButton >> dismiss [

	popover ifNotNil: [ popover dismiss ]
]

{ #category : #accessing }
AlcePopOverMenuButton >> help: aString [ 
	button help: aString
]

{ #category : #initialization }
AlcePopOverMenuButton >> icon: anIcon [

	button icon: anIcon
]

{ #category : #initialization }
AlcePopOverMenuButton >> initializePresenter [ 
	super initializePresenter.
	button := self newButton.
	button action: [ self showActions ].
]

{ #category : #initialization }
AlcePopOverMenuButton >> instantiateLayout [

	^ SpBoxLayout newTopToBottom
		  borderWidth: 10;
		  spacing: 5;
		  yourself
]

{ #category : #initialization }
AlcePopOverMenuButton >> instantiatePopover [

	popover ifNotNil: [ popover dismiss ].
	(popover := self newPopover)
		relativeTo: self;
		position: SpPopoverPosition right.
	^ popover
]

{ #category : #initialization }
AlcePopOverMenuButton >> instantiatePresenterWith: haloLayout [

	^ SpPresenter new
		  layout: haloLayout;
		  yourself
]

{ #category : #accessing }
AlcePopOverMenuButton >> label: aString [ 
	button label: aString
]

{ #category : #accessing }
AlcePopOverMenuButton >> name: aString [ 
	button label: aString
]

{ #category : #initialization }
AlcePopOverMenuButton >> showActions [

	| halo haloLayout |
	popover := self instantiatePopover.
	haloLayout := self instantiateLayout.

	actions do: [ :action | 
		haloLayout add: ((action instantiateElementWith: self)
				 label: action name;
				 action: [ 
					 self dismiss.
					 action execute ] yourself) ].

	halo := self instantiatePresenterWith: haloLayout.

	popover presenter: halo.
	popover popup
]
