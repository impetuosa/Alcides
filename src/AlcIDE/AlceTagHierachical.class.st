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

	| root tagToEntities createdNodes dependencies businessNode |
	element ifNil: [ ^ self ].
	mooseModel ifNil: [ ^ self ].
	categories selectedItem ifNil: [ ^ self ].


	"	h dependenciesToNodes: (relatedModules at: m value)  "

	"root addAll: nodes values. "



	root := HNode new name: 'Root'.
	createdNodes := Dictionary new.

	businessNode := createdNodes at: #default put: (HNode new
			                 name: 'Business';
			                 color: Color gray).


	tagToEntities := categories selectedItem markedTags flatCollect: [ 
		                 :tag | 
		                 tag taggedEntities
			                 select: [ :e | e isKindOf: AlcixReference ]
			                 thenCollect: [ :e | tag -> e ] ].

	" Initial clustering. Creating nodes per tag to contain nodes per model "
	tagToEntities do: [ :assoc | 
		| tagNode modelNode |
		tagNode := createdNodes at: assoc key ifAbsentPut: [ 
			           tagNode := HNode new
				                      name: assoc key name;
				                      color: assoc key color.
			           root add: tagNode.
			           tagNode ].
		modelNode := createdNodes
			             at: assoc value
			             ifAbsentPut: [ modelNode := HNode new name: assoc value name. tagNode add: modelNode . tagNode  ].
		].
	" Clustering the untagged modules  "
	element references do: [ :r | 
		createdNodes at: r ifAbsentPut: [ 
			| modelNode |
			modelNode := createdNodes
				             at: r
				             ifAbsentPut: [ HNode new name: r name ].
			businessNode add: modelNode.
			businessNode
	 ] ].
	businessNode children ifNotEmpty: [ root add: businessNode ].

	dependencies := Dictionary new.

	element references do: [ :ref | 
		((self colorsFor: ref)" reject: [ :tagAssoc | 
			 ref allTags includes: tagAssoc tag ]") do: [ :tagAssoc | 
			(dependencies at: (createdNodes at: ref) ifAbsentPut: [ Set new ]) 
				add: (createdNodes at: tagAssoc entity) ] ].



	dependencies associations do: [ :assoc | 
		assoc key dependenciesToNodes: assoc value asOrderedCollection ].
	root open



	"
	HSimpleVisualizationBuilder new
		rootNode: root;
		build;
		in: [ :b | b canvas openWithTitle: 'Hierarchycal Visualizations' ]"
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

	^ anEntity parentalModule name
]
