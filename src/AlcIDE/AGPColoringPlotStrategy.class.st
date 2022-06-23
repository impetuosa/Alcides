Class {
	#name : #AGPColoringPlotStrategy,
	#superclass : #AGPMappingStrategy,
	#category : #'AlcIDE-Clustering'
}

{ #category : #'as yet unclassified' }
AGPColoringPlotStrategy >> applyInto: anAlceGraphPlotter forRelationFrom: aFamixTag to: aColor [

	(anAlceGraphPlotter shapeForEntity: aFamixTag) innerShape color: aColor translucent 
]
