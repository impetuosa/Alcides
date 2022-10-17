Class {
	#name : #AlceGraphToRoassalHighlightNode,
	#superclass : #Object,
	#instVars : [
		'mapped',
		'processing',
		'cluster',
		'element',
		'buildingRoassalNode'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #accessing }
AlceGraphToRoassalHighlightNode >> cluster: anAlceClusteringVariables [ 
	cluster := anAlceClusteringVariables
]

{ #category : #accessing }
AlceGraphToRoassalHighlightNode >> element: anAlcixForm [ 
	element := anAlcixForm
]

{ #category : #initialization }
AlceGraphToRoassalHighlightNode >> initialize [

	super initialize.
	mapped := Dictionary new.

]

{ #category : #accessing }
AlceGraphToRoassalHighlightNode >> mapped [
	^ mapped
]

{ #category : #initialization }
AlceGraphToRoassalHighlightNode >> processNode: aNode [

	| relations |
	(aNode isTag or: [ aNode isColor ]) ifTrue: [ ^ self ].
	relations := cluster graph arcsFromObject: aNode.
	relations ifNil: [ ^ self ].

	processing := aNode.
	buildingRoassalNode := mapped at: aNode ifAbsentPut: [ 
		                       HNode new
			                       rawModel: aNode;
			                       name: aNode name;
			                       yourself ].

	relations do: [ :relation | relation acceptVisitor: self ].

]

{ #category : #visiting }
AlceGraphToRoassalHighlightNode >> visitDirectedArcNamedActivates: aGTEDirectedNamedArc [

	^ self visitDirectedArcNamedReads: aGTEDirectedNamedArc
]

{ #category : #visiting }
AlceGraphToRoassalHighlightNode >> visitDirectedArcNamedArchitecturalRole: aGTEDirectedNamedArc [

	| ownerx |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	buildingRoassalNode color: ownerx color
]

{ #category : #visiting }
AlceGraphToRoassalHighlightNode >> visitDirectedArcNamedBelongsTo: aGTEDirectedNamedArc [

	| ownerx ownerHnode |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	ownerx = element ifTrue: [ ^ self  ].
	ownerHnode := mapped at: ownerx ifAbsentPut: [ 
		              HNode new
			              rawModel: ownerx;
			              name: ownerx name;
			              yourself ].
	ownerHnode addChild: buildingRoassalNode 
]

{ #category : #visiting }
AlceGraphToRoassalHighlightNode >> visitDirectedArcNamedReads: aGTEDirectedNamedArc [

	| ownerx ownerHnode |
	ownerx := aGTEDirectedNamedArc to readValueFrom: cluster graph.
	ownerx = element ifFalse: [ 
		ownerHnode := mapped at: ownerx ifAbsentPut: [ 
			              HNode new
				              rawModel: ownerx;
				              name: ownerx name;
				              yourself ].
		buildingRoassalNode dependencyTo: ownerHnode ]
]

{ #category : #visiting }
AlceGraphToRoassalHighlightNode >> visitDirectedArcNamedWrites: aGTEDirectedNamedArc [

	self visitDirectedArcNamedReads: aGTEDirectedNamedArc
]
