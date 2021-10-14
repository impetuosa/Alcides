Class {
	#name : #AlceColorStrategySelectorWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'strategies',
		'instances',
		'creatingInstancesWith',
		'selectingCategory'
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
		  ifNil: [ {  } ]
		  ifNotNil: [ :item | item colorsFor: anEntity ]
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> createNewInstanceFor: anItem [

	^ (creatingInstancesWith value: anItem)
		  selectingCategory: selectingCategory;
		  yourself
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
AlceColorStrategySelectorWidget >> reset [

	instances valuesDo: [ :v | 
		v reset. 
		v selectingCategory: selectingCategory ]
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> selectedItem [

	^ strategies selectedItem ifNil: [ nil ] ifNotNil: [ 
		  instances
			  at: strategies selectedItem
			  ifAbsentPut: [ 
			  self createNewInstanceFor: strategies selectedItem ] ]
]

{ #category : #'as yet unclassified' }
AlceColorStrategySelectorWidget >> selectingCategory: aFamixTagCategory [

	selectingCategory := aFamixTagCategory.
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
