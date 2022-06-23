Class {
	#name : #AlceGraphToRoassalGraphHL,
	#superclass : #Object,
	#instVars : [
		'mapped',
		'processing',
		'cluster',
		'element',
		'buildingRoassalNode',
		'architectures'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #'as yet unclassified' }
AlceGraphToRoassalGraphHL >> architectureComposites [

	^ architectures
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> architectureFor: aTag andClass: aClass [

	| containers container clazz |
	containers := architectures
		              at: aTag
		              ifAbsentPut: [ OrderedCollection new ].

	container := containers
		             detect: [ :shape | shape rawModel = aClass container ]
		             ifNone: [ 
			             container := HNode new
				                          name: aClass container name;
				                          rawModel: aClass container;
				                          color: aTag color;
				                          yourself.
			             containers add: container.
			             container ].
	^ container children
		  detect: [ :shape | shape rawModel = aClass ]
		  ifNone: [ 
			  clazz := HNode new
				           name: aClass name;
				           rawModel: aClass;
				           color: aTag color;
				           yourself.
			  container addChild: clazz.
			  clazz ]
]

{ #category : #accessing }
AlceGraphToRoassalGraphHL >> cluster: anAlceClusteringVariables [ 
	cluster := anAlceClusteringVariables
]

{ #category : #accessing }
AlceGraphToRoassalGraphHL >> element: anAlcixForm [ 
	element := anAlcixForm
]

{ #category : #initialization }
AlceGraphToRoassalGraphHL >> initialize [

	super initialize.
	mapped := Dictionary new.
	architectures := Dictionary new.

]

{ #category : #initialization }
AlceGraphToRoassalGraphHL >> isLanguageElement: aNode [

	^ (((cluster graph arcsFromObject: aNode)
		    detect: [ :a | a name = #architecturalRole ]
		    ifNone: [ ^ false ]) to readValueFrom: cluster graph) name
	  = #Language
]

{ #category : #accessing }
AlceGraphToRoassalGraphHL >> mapped [
	^ mapped
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> nameFor: ownerx [

	^ ownerx name
]

{ #category : #initialization }
AlceGraphToRoassalGraphHL >> processNode: aNode [

	| relations |
	(aNode isKindOf: AlcixAccessModule) ifTrue: [ ^ self ].
	(aNode isTag or: [ aNode isColor ]) ifTrue: [ ^ self ].
	(self isLanguageElement: aNode) ifTrue: [ ^ self ].
	relations := cluster graph arcsFromObject: aNode.
	relations ifNil: [ ^ self ].

	processing := aNode.
	buildingRoassalNode := self shapeFor: aNode.
	relations do: [ :relation | relation acceptVisitor: self ]
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> shapeFor: ownerx [

	| composite |
	^ mapped at: ownerx ifAbsentPut: [ 
		  composite := HNode new.
		  composite
			  name: (self nameFor: ownerx);
			  rawModel: ownerx;
			  yourself ]
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> visitDirectedArcNamedActivates: aGTEDirectedNamedArc [

	| ownerx ownerHnode |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	(self isLanguageElement: ownerx) ifTrue: [ ^ self ].
	ownerx = element ifFalse: [ 
		'adding dep' traceCr.
		ownerHnode := self shapeFor: ownerx.
		ownerHnode := self shapeFor: ownerx.
		buildingRoassalNode dependencyTo: ownerHnode ]
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> visitDirectedArcNamedArchitecturalRole: aGTEDirectedNamedArc [

	| ownerx |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	(self isLanguageElement: ownerx) ifTrue: [ ^ self ].
	buildingRoassalNode color: ownerx color.

	(self
		 architectureFor: ownerx
		 andClass: (processing userType isUnknown
				  ifTrue: [ processing ]
				  ifFalse: [ processing userType ])) addChild: buildingRoassalNode
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> visitDirectedArcNamedBelongsTo: aGTEDirectedNamedArc [

"	| ownerx ownerHnode |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	(self isLanguageElement: ownerx) ifTrue: [ ^ self ].
	ownerx = element ifTrue: [ ^ self ].
	ownerHnode := self shapeFor: ownerx.

	self
		connect: buildingRoassalNode
		to: ownerHnode
		color: Color gray translucent
		width: 2
		dashes: #( 3 3 )
		markerEnd: (RSShapeFactory arrow
				 size: 20;
				 color: Color gray translucent;
				 yourself)
		model: aGTEDirectedNamedArc"
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> visitDirectedArcNamedReads: aGTEDirectedNamedArc [

	| ownerx ownerHnode |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	(self isLanguageElement: ownerx) ifTrue: [ ^ self ].
	ownerx = element ifFalse: [ 
		ownerHnode := self shapeFor: ownerx.
		buildingRoassalNode dependencyTo: ownerHnode ]
]

{ #category : #visiting }
AlceGraphToRoassalGraphHL >> visitDirectedArcNamedWrites: aGTEDirectedNamedArc [

	self visitDirectedArcNamedReads: aGTEDirectedNamedArc
]
