Class {
	#name : #AlceColorStrategySelectorWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'strategies',
		'instances',
		'creatingInstancesWith'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceColorStrategySelectorWidget class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: #strategies;
		  yourself
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> colorsFor: anEntity [

	^ self selectedItem
		  ifNil: [ { Color transparent } ]
		  ifNotNil: [ :item | item colorsFor: anEntity ]
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> createNewInstanceFor: anItem [

	^ creatingInstancesWith value: anItem
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> creatingInstancesWith: aBlock [

	creatingInstancesWith := aBlock
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> initializePresenters [

	super initializePresenters.
	strategies := self newDropList.
	instances := Dictionary new.
	self itemsAreStrategyClasses. 
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> itemsAreStrategies [

	self creatingInstancesWith: [ :a | a ]
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> itemsAreStrategyClasses [

	self creatingInstancesWith: [ :a | a new ]
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> selectedItem [

	^ strategies selectedItem ifNil: [ nil ] ifNotNil: [ 
		  instances
			  at: strategies selectedItem
			  ifAbsentPut: [ 
			  self createNewInstanceFor: strategies selectedItem ] ]
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> strategies: aCollection [
	strategies items: aCollection
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> whenSelectionChangedDo: aBlock [

	" No selection available. Just to keep the isolation "

	strategies whenSelectionChangedDo: [ aBlock cull: self selectedItem ]
]
