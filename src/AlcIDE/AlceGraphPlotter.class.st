Class {
	#name : #AlceGraphPlotter,
	#superclass : #AlceGraphMapper,
	#instVars : [
		'canvas',
		'shapesLayout',
		'lineBuilder',
		'allShapes',
		'baseNode',
		'linkStyler',
		'interactionBuildingBlock'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #adding }
AlceGraphPlotter >> addShapesToCanvas [
	self canvas addAll: mappeEntities.
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> afterApply [
	relationMappingRules do: [ :rule | rule afterApply ]
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> applyLayout [ 
	mappeEntities do: [ : s | s adjustToChildren  ].
	shapesLayout on: mappeEntities.
	
]

{ #category : #accessing }
AlceGraphPlotter >> canvas [
	^ canvas ifNil: [ canvas := RSCanvas new ]
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> defaultEntityMapperBlock [

	^ [ :cls | 
	  RSEllipse new
		  draggable;
		  popup;
		  model: cls;
		  yourself ]
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> defaultInteractionBuildingBlock [

	^ [ :a | 
	  a
		  popup;
		  @ (GraphGhostDraggable new color: Smalltalk ui theme caretColor);
		  @ GraphOnTopWhenPositionChanged new;
		  @ GraphResizeParentWhenChildMoves new;
		  yourself ]
]

{ #category : #accessing }
AlceGraphPlotter >> finalize [ 
	super finalize. 
	allShapes := nil.
	entityMappingRules := nil. 
	relationMappingRules := nil.
	baseNode := nil.
	canvas := nil .
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> initialize [

	super initialize.
	
	
	
	shapesLayout := RSClusterLayout.
	doNotMapBlock := [ :a | false ].
	linkStyler := HLinkStyler new.
	interactionBuildingBlock := self defaultInteractionBuildingBlock. 
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> installInteractions [

	allShapes do: [ :s | s innerShape announcer: self interactionsAnnouncer ].
	self pushFrontShapes: mappeEntities .
]

{ #category : #running }
AlceGraphPlotter >> interactionBuildingBlock: aBlock [

	interactionBuildingBlock := aBlock
]

{ #category : #running }
AlceGraphPlotter >> interactionsAnnouncer [


	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new.
	interactionBuildingBlock value: baseNode.

	^ baseNode announcer
]

{ #category : #accessing }
AlceGraphPlotter >> lineBuilder [

	^ lineBuilder ifNil: [ 
		  lineBuilder := RSLineBuilder line
			                 color: Color gray;
			                 canvas: self canvas;
			                 shapes: mappeEntities;
			                 yourself ]
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> mapAllNodes [
	super mapAllNodes .
	allShapes := mappeEntities copy
]

{ #category : #running }
AlceGraphPlotter >> mapEntity: anEntity [

	| shape innerShape |
	shape := RSComposite new.
	innerShape := super mapEntity: anEntity.
	shape model: anEntity.
	shape setAsInnerShape: innerShape.
	^ shape
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> plot [
	self mapAllNodes. 
	self applyRelationRepresentations. 
	self addShapesToCanvas. 
	self afterApply.
	self applyLayout.
	self afterApply.
	self applyLayout.
	self prepareCanvas.
	self installInteractions. 
	^ self canvas 
]

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> prepareCanvas [
	self canvas @ (RSCanvasController new
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

{ #category : #'as yet unclassified' }
AlceGraphPlotter >> pushFrontShapes: aSet [

	aSet do: [ :s | 
		s pushFront.
		self pushFrontShapes: (s schildren ifNil: [ #(  ) ]).
		s innerShape pushBack ]
]

{ #category : #running }
AlceGraphPlotter >> shapeForEntity: anEntity [

	^ allShapes detect: [ :s | s model = anEntity ]
]

{ #category : #accessing }
AlceGraphPlotter >> shapesLayout: aClass [ 
	shapesLayout := aClass
]
