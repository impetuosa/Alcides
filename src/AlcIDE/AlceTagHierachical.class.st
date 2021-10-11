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

	(self hasWindow not or: [ self root isOpen not ]) ifTrue: [ ^ false ].
	(anEntity isKindOf: AlcixModel) ifTrue: [ 
		self mooseModel: anEntity.
		^ true ].

	(anEntity isKindOf: AlcixEntity) ifTrue: [ 
		mooseModel ifNil: [ self mooseModel: anEntity mooseModel ] ].
	^ false
]

{ #category : #visiting }
AlceTagHierachical >> coloringStrategyFor: aClass [

	^ mooseModel coloringStrategyFor: aClass
]

{ #category : #visiting }
AlceTagHierachical >> colorsFor: anAlcixClass [

	^ strategies colorsFor: anAlcixClass
]

{ #category : #visiting }
AlceTagHierachical >> initCanvas: canvas [

	canvas @ (RSCanvasController new
		 noLegend;
		 in: [ :i | 
			 canvas newAnimation
				 duration: 500 milliSeconds;
				 onStepDo: [ canvas signalUpdate ];
				 when: RSAnimationEndEvent
				 do: [ i configuration noZoomToFitOnExtendChanged ].
			 i configuration
				 maxScale: 3;
				 minScale: 0.1
			 "useBasicZoom;" ];
		 yourself)
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

	| root tagToEntities createdNodes dependencies businessNode builder |
	element ifNil: [ ^ self ].
	mooseModel ifNil: [ ^ self ].
	categories selectedItem ifNil: [ ^ self ].

	self initCanvas: aCanvas.

	root := HNode new
		        name: 'Root';
		        rawModel: element;
		        yourself.
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
				                      color: assoc key color;
				                      rawModel: assoc key;
				                      yourself.
			           root add: tagNode.
			           tagNode ].
		modelNode := createdNodes at: assoc value ifAbsentPut: [ 
			             modelNode := HNode new
				                          name: assoc value name;
				                          rawModel: assoc value;
				                          yourself.
			             tagNode add: modelNode.
			             modelNode addAll:
				             (self nodesPerKind: assoc value into: createdNodes).
			             modelNode ] ].
	" Clustering the untagged modules  "
	element references do: [ :r | 
		createdNodes at: r ifAbsentPut: [ 
			| modelNode |
			modelNode := createdNodes at: r ifAbsent: [ 
				             modelNode := HNode new
					                          name: r name;
					                          rawModel: r;
					                          yourself.
				             createdNodes at: r put: modelNode.
				             modelNode addAll:
					             (self nodesPerKind: r into: createdNodes).
				             modelNode ].

			businessNode add: modelNode.
			modelNode ] ].
	businessNode children ifNotEmpty: [ root add: businessNode ].

	dependencies := Dictionary new.

	createdNodes keys
		select: [ :a | a isKindOf: AlcixEntity ]
		thenDo: [ :ref | 
			(self colorsFor: ref)
				reject: [ :tagAssoc | 
					(ref isKindOf: AlcixUserType) and: [ 
						ref container isNotNil and: [ 
							ref container allTags includes: tagAssoc tag ] ] ]
				thenDo: [ :tagAssoc | "do:  :tagAssoc | "
					(dependencies at: (createdNodes at: ref) ifAbsentPut: [ Set new ]) 
						add: (createdNodes at: tagAssoc entity) ] ].


	dependencies associations do: [ :assoc | 
		assoc key dependenciesToNodes: assoc value asOrderedCollection ].


	builder := HSimpleVisualizationBuilder new
		           rootNode: root;
		           container: aCanvas.
	builder lineBuilder width: 2.

	builder build.
	root collapseChildren.
	root children do: [ :child | 
		child collapseChildren.
		child position: nil.
		child children do: [ :ch2 | 
			ch2 collapseChildren.
			ch2 position: nil ] ].
	builder layoutOn: builder container nodes parent: root.
	builder container signalUpdate
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

{ #category : #visiting }
AlceTagHierachical >> nodesPerKind: aReference into: createdNodes [

	| toAdd entries |
	toAdd := OrderedCollection new.

	entries := aReference types.
	(entries groupedBy: #class) associations do: [ :as | 
		| group |
		group := HNode new
			         name: as key name;
			         rawModel: as value;
			         yourself.
		toAdd add: group.
		group addAll: (as value collect: [ :t | 
				 createdNodes at: t ifAbsentPut: [ 
					 HNode new
						 name: t name;
						 rawModel: t;
						 yourself ] ]) ].
	^ toAdd
]
