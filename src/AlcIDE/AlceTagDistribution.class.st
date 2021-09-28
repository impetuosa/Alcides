Class {
	#name : #AlceTagDistribution,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'colorSelector',
		'mooseModel',
		'categories',
		'strategies'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlceTagDistribution class >> defaultSpec [

	^ self basicDefaultSpec
		  add: (SpBoxLayout newLeftToRight
				   add: #strategies;
				   add: #categories)
		  height: 50;
		  add: (SpBoxLayout newLeftToRight
				   add: #viewport);
		  add: #refresh height: self toolbarHeight;
		  yourself
]

{ #category : #accessing }
AlceTagDistribution class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcTagDistributionBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #accessing }
AlceTagDistribution class >> title [
	^ 'Tag distribution'
]

{ #category : #visiting }
AlceTagDistribution >> accept: anEntity [

	(anEntity isKindOf: AlcixModel) ifTrue: [ 
		self mooseModel: anEntity.
		^ true ].

	(anEntity isKindOf: AlcixEntity) ifTrue: [ 
		mooseModel ifNil: [ self mooseModel: anEntity mooseModel ] ].
	^ false
]

{ #category : #visiting }
AlceTagDistribution >> coloringStrategyFor: aClass [

	| inst |
	^ mooseModel coloringStrategies
		  detect: [ :a | a class = aClass ]
		  ifNone: [ 
			  inst := aClass new.
			  mooseModel installColoringStrategy: inst.
			  inst ]
]

{ #category : #visiting }
AlceTagDistribution >> colorsFor: anAlcixClass [

	^ strategies colorsFor: anAlcixClass
]

{ #category : #visiting }
AlceTagDistribution >> initializePresenters [

	super initializePresenters.
	strategies := self instantiate: AlceColorStrategySelectorWidget.
	strategies strategies: AlceColoringStrategy allSubclasses.
	strategies whenSelectionChangedDo: [ self refresh ].
	categories := self newDropList.
	categories
		whenSelectionChangedDo: [ 
			strategies selectingCategory: categories selectedItem ];
		display: [ :a | a name ]
]

{ #category : #visiting }
AlceTagDistribution >> loadChart: aCanvas withElement: element [

	| allModels |
	element ifNil: [ ^ self ].
	mooseModel ifNil: [ ^ self ].
	categories selectedItem ifNil: [ ^ self ].
	self initCanvas: aCanvas.
	allModels := mooseModel references flatCollect: [ :m | 
		             ((self colorsFor: m) collect: #tag) asSet
			             asOrderedCollection collect: [ :t | t -> m ] ].


	HDistributionMap new
		elements: categories selectedItem markedTags;
		childrenBlock: [ :tag | 
			allModels select: [ :c | c key = tag ] thenCollect: #value ];
		propertyBlock: [ :val | 
			(allModels select: [ :m | m value = val ]) size ];
		colorMap: RSColorPalette diverging rdgy4;
		container: aCanvas;
		build
]

{ #category : #visiting }
AlceTagDistribution >> mooseModel: aModel [

	mooseModel := aModel.
	categories items: aModel allTagCategories.
	aModel ifNil: [ strategies itemsAreStrategyClasses ] ifNotNil: [ 
		strategies creatingInstancesWith: [ :a | 
			self coloringStrategyFor: a ] ]
]
