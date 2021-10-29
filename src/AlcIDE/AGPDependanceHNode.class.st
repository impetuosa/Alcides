Class {
	#name : #AGPDependanceHNode,
	#superclass : #AGPMappingStrategy,
	#category : #'AlcIDE-Clustering'
}

{ #category : #testing }
AGPDependanceHNode >> applyInto: anAlceGraphPlotter forRelationFrom: anEntity to: aDestinationEntity [

	| fromShape toShape |
	fromShape := anAlceGraphPlotter hnodeForEntity: anEntity.
	toShape := anAlceGraphPlotter hnodeForEntity: aDestinationEntity.
	fromShape dependencyTo: toShape
]
