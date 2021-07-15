Class {
	#name : #AlceRoassalWidget,
	#superclass : #AlceAbstractWidget,
	#instVars : [
		'viewport',
		'refresh'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceRoassalWidget class >> defaultSpec [
	^ super defaultSpec
		add: #viewport;
		add: #refresh height: self toolbarHeight; 
		yourself
]

{ #category : #specs }
AlceRoassalWidget class >> isAbstract [

	^ self = AlceRoassalWidget
]

{ #category : #initialization }
AlceRoassalWidget >> element [

	^ toSelect
]

{ #category : #initialization }
AlceRoassalWidget >> followAction [

	self viewport script: [ :aCanvas | 
		self loadChart: aCanvas withElement: self element ]
]

{ #category : #initialization }
AlceRoassalWidget >> initializePresenters [

	super initializePresenters.
	viewport := self instantiate: SpRoassalPresenter . 
	refresh := self newButton. 
	refresh label: 'Refresh'.
	refresh action: [ self refresh ]. 
]

{ #category : #initialization }
AlceRoassalWidget >> loadChart: aCanvas withElement: anElement [ 

	self subclassResponsibility

]

{ #category : #initialization }
AlceRoassalWidget >> refresh [

	self followAction
]

{ #category : #initialization }
AlceRoassalWidget >> viewport [

	^ (viewport isKindOf: SpLabelPresenter)
		  ifTrue: [ viewport := self instantiate: SpRoassalPresenter ]
		  ifFalse: [ viewport ]
]
