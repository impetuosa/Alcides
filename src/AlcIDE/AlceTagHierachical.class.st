Class {
	#name : #AlceTagHierachical,
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
AlceTagHierachical class >> defaultSpec [

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
AlceTagHierachical class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcTagHierarchyBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #accessing }
AlceTagHierachical class >> title [
	^ 'Tag hierarchical'
]

{ #category : #visiting }
AlceTagHierachical >> accept: anEntity [

	(anEntity isKindOf: AlcixModel) ifTrue: [ 
		self mooseModel: anEntity.
		^ true ].

	(anEntity isKindOf: AlcixEntity) ifTrue: [ 
		mooseModel ifNil: [ self mooseModel: anEntity mooseModel ] ].
	^ false
]

{ #category : #visiting }
AlceTagHierachical >> coloringStrategyFor: aClass [

	| inst |
	^ mooseModel coloringStrategies
		  detect: [ :a | a class = aClass ]
		  ifNone: [ 
			  inst := aClass new.
			  mooseModel installColoringStrategy: inst.
			  inst ]
]

{ #category : #visiting }
AlceTagHierachical >> colorsFor: anAlcixClass [

	^ strategies colorsFor: anAlcixClass
]

{ #category : #visiting }
AlceTagHierachical >> initializePresenters [

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
AlceTagHierachical >> loadChart: aCanvas withElement: element [

	| allModels root nodes relatedModules |
	element ifNil: [ ^ self ].
	mooseModel ifNil: [ ^ self ].
	categories selectedItem ifNil: [ ^ self ].

	relatedModules := Dictionary new.

	allModels := mooseModel references flatCollect: [ :m | 
		             (self colorsFor: m) asSet asOrderedCollection collect: [ 
			             :t | t -> m ] ].

	allModels do: [ :m | 
		(relatedModules at: m value ifAbsentPut: [ OrderedCollection new ]) 
			add: (HNode new name: (self nameForEntityModule: m key entity)) ].

	root := HNode new name: 'Root'.

	nodes := (categories selectedItem markedTags collect: [ :t | 
		          t -> (HNode new name: t name) ]) asDictionary.

	root addAll: nodes values.


	allModels do: [ :m | 
		| h |
		h := HNode new.
		h name: m value name.
		(nodes at: m key tag) add: h.
		h dependenciesToNodes: (relatedModules at: m value) ].

	HSimpleVisualizationBuilder new
		rootNode: root;
		build;
		in: [ :b | b canvas openWithTitle: 'Hierarchycal Visualizations' ]
]

{ #category : #visiting }
AlceTagHierachical >> mooseModel: aModel [

	mooseModel := aModel.
	categories items: aModel allTagCategories.
	aModel ifNil: [ strategies itemsAreStrategyClasses ] ifNotNil: [ 
		strategies creatingInstancesWith: [ :a | 
			self coloringStrategyFor: a ] ]
]

{ #category : #visiting }
AlceTagHierachical >> nameForEntityModule: anEntity [ 
	^ anEntity parentalModule 
]
