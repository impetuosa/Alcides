Class {
	#name : #AGPLinkingPlotStrategy,
	#superclass : #AGPMappingStrategy,
	#category : #'AlcIDE-Clustering'
}

{ #category : #'as yet unclassified' }
AGPLinkingPlotStrategy >> applyInto: anAlceGraphPlotter forRelationFrom: anEntity to: anOtherEntity [

	anAlceGraphPlotter lineBuilder
		edgeFrom: (anAlceGraphPlotter shapeForEntity: anEntity) innerShape 
		to: (anAlceGraphPlotter shapeForEntity: anOtherEntity) innerShape
]
