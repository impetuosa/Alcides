Class {
	#name : #AlceBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'widget',
		'widgetClass',
		'window',
		'drndr'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #widget;
		  yourself
]

{ #category : #specs }
AlceBrowser class >> runMe [ 
	self error: 'This class cannot runme out of the box, is just a frame'
]

{ #category : #specs }
AlceBrowser class >> runMeWith: aClass [

	^ self
		  runMeWith: aClass
		  following: self currentApplication defaultBus
]

{ #category : #specs }
AlceBrowser class >> runMeWith: aClass following: aBus [

	^ (self on: self newModel)
		  widgetClass: aClass;
		  openWithSpec;
		  followBus: aBus;
		  yourself
]

{ #category : #initialization }
AlceBrowser >> followAction [

	^ widget followAction
]

{ #category : #initialization }
AlceBrowser >> initializePresenters [

	super initializePresenters.


	self widgetClass ifNotNil: [ 
		widget := self instantiate: self widgetClass ]
]

{ #category : #initialization }
AlceBrowser >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	window := aWindow.
	widget ifNotNil: [ window title: widget title ]
]

{ #category : #initialization }
AlceBrowser >> instantiateWidget: aWidget [

	| b |
	b := self instantiate: aWidget.
	b browser: self.
	^ b
]

{ #category : #initialization }
AlceBrowser >> miSelectedItem [

	^ widget miSelectedItem
]

{ #category : #initialization }
AlceBrowser >> selectEntity: anEntity [

	widget selectEntity: anEntity.

]

{ #category : #initialization }
AlceBrowser >> widgetClass [

	^ widgetClass
]

{ #category : #initialization }
AlceBrowser >> widgetClass: aClass [

	widgetClass := aClass.
	widget := self instantiateWidget: self widgetClass.

	window ifNotNil: [ window title: widget title ]
]
