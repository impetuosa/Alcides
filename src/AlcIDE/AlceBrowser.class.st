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
AlceBrowser class >> currentApplication [
	^ MiApplication current
]

{ #category : #specs }
AlceBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #buttonFollow width: 65;
				add: #buttonFreeze width: 60;
				add: #buttonHighlight width: 80;
				add: SpBoxLayout newHorizontal expand: true;
				add: #busButton;
				add: SpBoxLayout newHorizontal expand: true;
				add: #buttonInspect width: self iconWidth;
				add: #buttonPropagate expand: false;
				add: #buttonHelp width: self iconWidth;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
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

{ #category : #'as yet unclassified' }
AlceBrowser >> adaptToDropInto: aDropDestination [

	window close.
	^ widget
]

{ #category : #initialization }
AlceBrowser >> application [
	 ^ application
]

{ #category : #'as yet unclassified' }
AlceBrowser >> canBeAdaptedToDropInto: aDestination [
	^ true
]

{ #category : #initialization }
AlceBrowser >> close [ 
	 window close 
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

{ #category : #testing }
AlceBrowser >> noteThatWidgetHasBeenClosed: anAlceSourceCodeWidget [

	widget = anAlceSourceCodeWidget ifTrue: [ self close ]
]

{ #category : #initialization }
AlceBrowser >> propagate: aWidget [ 
	 self propagate. 
]

{ #category : #initialization }
AlceBrowser >> selectEntity: anEntity [

	widget selectEntity: anEntity.

]

{ #category : #accessing }
AlceBrowser >> widget: anAlceInvocableWidget [ 
	widget := anAlceInvocableWidget.
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
