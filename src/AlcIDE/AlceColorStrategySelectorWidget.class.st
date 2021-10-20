Class {
	#name : #AlceColorStrategySelectorWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'strategies',
		'categories',
		'instances',
		'creatingInstancesWith',
		'selectingCategory',
		'mooseModel',
		'accept'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceColorStrategySelectorWidget class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #strategies;
				   add: #categories;
				   yourself);
		  add: #accept
]

{ #category : #visiting }
AlceColorStrategySelectorWidget >> acceptColoring [

	mooseModel selectedColoringStrategy: (self selectedItem
			 selectingCategory: selectingCategory;
			 reset;
			 yourself)
]

{ #category : #accessing }
AlceColorStrategySelectorWidget >> action: aFullBlockClosure [ 

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
	strategies items: (AlceColoringStrategy allSubclasses).
	categories := self newDropList.
	categories
		whenSelectionChangedDo: [ 
			self selectingCategory: categories selectedItem ];
		display: [ :a | a name ].

	instances := Dictionary new.
	accept := self newButton. 
	accept label: 'Accept'.
	accept action: [ self acceptColoring ].
	self mooseModel: MooseModelRoot root entities anyOne.
	self itemsAreStrategyClasses
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> itemsAreStrategies [

	self creatingInstancesWith: [ :a | a ]
]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> itemsAreStrategyClasses [

	self creatingInstancesWith: [ :a | a new ]
]

{ #category : #accessing }
AlceColorStrategySelectorWidget >> label: aString [ 

]

{ #category : #initialization }
AlceColorStrategySelectorWidget >> mooseModel: aModel [

	mooseModel := aModel.
	categories items: aModel allTagCategories.
	aModel ifNil: [ strategies itemsAreStrategyClasses ] ifNotNil: [ 
		self creatingInstancesWith: [ :a | 
			mooseModel coloringStrategyFor: a ] ]
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
