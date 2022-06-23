Class {
	#name : #AGPContainanceHNode,
	#superclass : #AGPMappingStrategy,
	#category : #'AlcIDE-Clustering'
}

{ #category : #testing }
AGPContainanceHNode >> applyInto: anAlceGraphPlotter forRelationFrom: anEntity to: aDestinationEntity [

		| fromShape toShape   |
	fromShape := anAlceGraphPlotter hnodeForEntity: anEntity.
	toShape := anAlceGraphPlotter hnodeForEntity: aDestinationEntity.
	anAlceGraphPlotter removeMappedEntity: toShape.
	fromShape addChild: toShape. 
	
	
]
