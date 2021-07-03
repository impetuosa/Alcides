Class {
	#name : #SpDropIn,
	#superclass : #SpPresenter,
	#instVars : [
		'dragHere',
		'presenters',
		'installingStrategy'
	],
	#category : #'AlcIDE-Spec'
}

{ #category : #initialization }
SpDropIn >> acceptDrop: aBlock [
 	dragHere acceptDrop: aBlock
]

{ #category : #accessing }
SpDropIn >> borderWidth: anInteger [ 
	 dragHere borderWidth: anInteger.
	dragHere borderColor: Color black .
]

{ #category : #'drag and drop' }
SpDropIn >> dropEnabled: aBoolean [ 
	dragHere dropEnabled: aBoolean 
]

{ #category : #testing }
SpDropIn >> hasLeft: aPresenter [

	presenters remove: aPresenter.
	layout removeAll.
	presenters do: [ :p | layout add: p ].
	layout add: dragHere height: 10
]

{ #category : #initialization }
SpDropIn >> initializePresenters [

	super initializePresenters.
	presenters := OrderedCollection new.
	dragHere := self instantiate: SpDragHere.
	dragHere borderWidth: 2.
	dragHere dropInto: self.

	self wantsDrop: [ :transfer :destination | 
		transfer canBeAdaptedToDropInto: destination ].
	self acceptDrop: [ :transfer :destination | 
		(destination install: transfer passenger)
			browser: self;
			whenClose: [ :widget | destination hasLeft: widget ];
			hasBeenReinstalled ].

	layout := self newLayout.
	layout add: dragHere
]

{ #category : #initialization }
SpDropIn >> install: aPresenter [

	| newPresenter |
	newPresenter := aPresenter adaptToDropInto: self.
	newPresenter owner: self.
	presenters add: newPresenter.

	layout removeAll.
	presenters do: [ :p | layout add: p ].
	layout add: dragHere height: 10.
	^ newPresenter
]

{ #category : #'as yet unclassified' }
SpDropIn >> installedPresenters [

	^ presenters
]

{ #category : #initialization }
SpDropIn >> newLayout [

	^ SpBoxLayout  newTopToBottom 
]

{ #category : #initialization }
SpDropIn >> wantsDrop: aBlock [
 	dragHere wantsDrop: aBlock
]
