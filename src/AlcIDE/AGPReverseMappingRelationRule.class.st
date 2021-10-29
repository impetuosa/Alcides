Class {
	#name : #AGPReverseMappingRelationRule,
	#superclass : #AGPMappingRelationRule,
	#category : #'AlcIDE-Clustering'
}

{ #category : #'as yet unclassified' }
AGPReverseMappingRelationRule >> readRelationValue: arc from: anAlceGraphPlotter [

	^ arc from readValueFrom: anAlceGraphPlotter graph
]

{ #category : #'as yet unclassified' }
AGPReverseMappingRelationRule >> relationsFor: anEntity from: aGraphPlotter [

	^ (aGraphPlotter graph arcsToObject: anEntity) select: [ :r | 
		  r name = arcName ]
]
