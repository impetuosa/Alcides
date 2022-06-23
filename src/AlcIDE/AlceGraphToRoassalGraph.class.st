Class {
	#name : #AlceGraphToRoassalGraph,
	#superclass : #Object,
	#instVars : [
		'mapped',
		'processing',
		'cluster',
		'element',
		'buildingRoassalNode',
		'architectures',
		'border',
		'lines',
		'fullCornerRadius',
		'baseNode',
		'menuInteraction'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #'as yet unclassified' }
AlceGraphToRoassalGraph >> architectureComposites [

	^ architectures
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> architectureFor: aTag andClass: aClass [

	| arch clzz |
	clzz := architectures
		        at: aClass
		        ifAbsentPut: [ OrderedCollection new ].
	^ clzz detect: [ :shape | shape model = aTag ] ifNone: [ 
		  arch := RSTitledComposite new
			          title: aTag name;
			          model: aTag;
			          color: aTag color;
			          layout: RSSimpleForceBasedLayout new;
			          yourself.
		  clzz add: arch.
		  arch ]
]

{ #category : #accessing }
AlceGraphToRoassalGraph >> cluster: anAlceClusteringVariables [ 
	cluster := anAlceClusteringVariables
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> connect: aShape to: anOtherShape color: aColor width: aWith dashes: anArray markerEnd: aMarker model: aGTEDirectedNamedArc [

	| line int |
	line := RSLine new
		        width: 2;
		        announcer: self nodeAnnouncer;
		        dashArray: anArray;
		        color: aColor;
		        withBorderAttachPoint;
		        from: aShape;
		        to: anOtherShape;
		        model: aGTEDirectedNamedArc;
		        markerEnd: aMarker;
		        yourself. "RSBezier new
		        controlPointsController: RSDirectedBezierCPAPController new;"
	int := RSLabeled new.
	int text: [ :a | a ifNotNil: [ a name ] ifNil: [ '' ] ].
	int location middle.
	line addInteraction: int.
	self lines add: line
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> cornerRadius [
	^ 7
]

{ #category : #accessing }
AlceGraphToRoassalGraph >> element: anAlcixForm [ 
	element := anAlcixForm
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> fullCornerRadius [
	^ fullCornerRadius ifNil: [ 
		fullCornerRadius := RSCornerRadius new 
			radius: self cornerRadius ]
]

{ #category : #initialization }
AlceGraphToRoassalGraph >> initialize [

	super initialize.
	mapped := Dictionary new.
	architectures := Dictionary new.
	border := RSBorder new
		          color: Color black muchDarker;
		          width: 1;
		          yourself
]

{ #category : #initialization }
AlceGraphToRoassalGraph >> isLanguageElement: aNode [

	^ (((cluster graph arcsFromObject: aNode)
		    detect: [ :a | a name = #architecturalRole ]
		    ifNone: [ ^ false ]) to readValueFrom: cluster graph) name
	  = #Language
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> lines [

	^ lines ifNil: [ lines := OrderedCollection new ]
]

{ #category : #accessing }
AlceGraphToRoassalGraph >> mapped [
	^ mapped
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> menuInteraction [

	^ menuInteraction
]

{ #category : #accessing }
AlceGraphToRoassalGraph >> menuInteraction: aRSMenuActivable [ 
	menuInteraction := aRSMenuActivable
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> nameFor: ownerx [

	^ ownerx name
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> nodeAnnouncer [
	"plug new events here"
	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		@ (HGhostDraggable new 
			color: Smalltalk ui theme caretColor);
		@ self menuInteraction;
		yourself.
	^ baseNode announcer
	
]

{ #category : #initialization }
AlceGraphToRoassalGraph >> processNode: aNode [

	| relations |
	(aNode isTag or: [ aNode isColor ]) ifTrue: [ ^ self ].
	(self isLanguageElement: aNode) ifTrue: [ ^ self ].
	relations := cluster graph arcsFromObject: aNode.
	relations ifNil: [ ^ self ].

	processing := aNode.
	buildingRoassalNode := self shapeFor: aNode.
	relations do: [ :relation | relation acceptVisitor: self ]
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> shapeFor: ownerx [

	| composite  |
	^ mapped at: ownerx ifAbsentPut: [ 
		  composite := RSTitle new.
		  composite
			  text: (self nameFor: ownerx);
			  model: ownerx;
			  yourself ]
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> visitDirectedArcNamedActivates: aGTEDirectedNamedArc [

	| ownerx ownerHnode |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	(self isLanguageElement: ownerx) ifTrue: [ ^ self ].
	ownerx = element ifFalse: [ 
		ownerHnode := self shapeFor: ownerx.
		self
			connect: buildingRoassalNode
			to: ownerHnode
			color: Color green muchDarker 
			width: 4
			dashes: #( 2 4 )
			markerEnd: (RSShapeFactory arrow
					 size: 20;
					 color: Color green muchDarker;
					 yourself)
			model: aGTEDirectedNamedArc ]
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> visitDirectedArcNamedArchitecturalRole: aGTEDirectedNamedArc [

	| ownerx |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	(self isLanguageElement: ownerx) ifTrue: [ ^ self ].
	buildingRoassalNode settingColor: ownerx color.

	(self architectureFor: ownerx andClass: processing userType) 
		silentAdd: buildingRoassalNode
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> visitDirectedArcNamedBelongsTo: aGTEDirectedNamedArc [

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
AlceGraphToRoassalGraph >> visitDirectedArcNamedReads: aGTEDirectedNamedArc [

	| ownerx ownerHnode |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	(self isLanguageElement: ownerx) ifTrue: [ ^ self ].
	ownerx = element ifFalse: [ 
		ownerHnode := self shapeFor: ownerx.
		self
			connect: buildingRoassalNode
			to: ownerHnode
			color: Color blue muchDarker
			width: 2
			dashes: #(  )
			markerEnd: (RSShapeFactory arrow
					 size: 20;
					 color: Color blue muchDarker;
					 yourself)
			model: aGTEDirectedNamedArc ]
]

{ #category : #visiting }
AlceGraphToRoassalGraph >> visitDirectedArcNamedWrites: aGTEDirectedNamedArc [

	self visitDirectedArcNamedReads: aGTEDirectedNamedArc
]
