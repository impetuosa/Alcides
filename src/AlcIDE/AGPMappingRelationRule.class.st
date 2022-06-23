Class {
	#name : #AGPMappingRelationRule,
	#superclass : #Object,
	#instVars : [
		'arcName',
		'strategy'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #testing }
AGPMappingRelationRule >> afterApply [
	strategy afterApply 
]

{ #category : #accessing }
AGPMappingRelationRule >> arcName: aString [ 
	arcName := aString
]

{ #category : #testing }
AGPMappingRelationRule >> beforeApply [
	strategy beforeApply 
]

{ #category : #'as yet unclassified' }
AGPMappingRelationRule >> buildRepresentationFor: anEntity into: anAlceGraphPlotter [

	| relations |
	relations := self relationsFor: anEntity from: anAlceGraphPlotter.

	relations do: [ :arc | 
		| destination |
		destination := self readRelationValue: arc from: anAlceGraphPlotter.
		strategy
			applyInto: anAlceGraphPlotter
			forRelationFrom: anEntity
			to: destination ]
]

{ #category : #'as yet unclassified' }
AGPMappingRelationRule >> preBuildRepresentation [

	strategy preBuildRepresentation
]

{ #category : #'as yet unclassified' }
AGPMappingRelationRule >> readRelationValue: arc from: anAlceGraphPlotter [

	^ arc to readValueFrom: anAlceGraphPlotter graph
]

{ #category : #'as yet unclassified' }
AGPMappingRelationRule >> relationsFor: anEntity from: aGraphPlotter [
	^ (aGraphPlotter graph arcsFromObject: anEntity) select: [ :r | r name = arcName ]
]

{ #category : #accessing }
AGPMappingRelationRule >> strategy: anAGPContainancePlotStrategy [ 
	strategy := anAGPContainancePlotStrategy
]
