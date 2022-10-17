Class {
	#name : #AGPColoringHNode,
	#superclass : #AGPMappingStrategy,
	#category : #'AlcIDE-Clustering'
}

{ #category : #testing }
AGPColoringHNode >> applyInto: anAlceGraphPlotter forRelationFrom: aFamixTag to: aColor [

	(anAlceGraphPlotter hnodeForEntity: aFamixTag) color: aColor translucent 
]
