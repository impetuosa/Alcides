Class {
	#name : #AGPMappingStrategy,
	#superclass : #Object,
	#category : #'AlcIDE-Clustering'
}

{ #category : #'as yet unclassified' }
AGPMappingStrategy class >> coloringStrategy [
	^ AGPColoringPlotStrategy new 
]

{ #category : #'as yet unclassified' }
AGPMappingStrategy class >> containanceStrategy [
	^ AGPContainancePlotStrategy new .
]

{ #category : #'as yet unclassified' }
AGPMappingStrategy class >> hnodeContainanceStrategy [

	^ AGPContainanceHNode new
]

{ #category : #'as yet unclassified' }
AGPMappingStrategy class >> hnodeDependenceStrategy [
	^ AGPDependanceHNode new
]

{ #category : #'as yet unclassified' }
AGPMappingStrategy class >> hnodeLinkingStrategy [
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
AGPMappingStrategy class >> hnodecoloringStrategy [
	^ AGPColoringHNode new
]

{ #category : #'as yet unclassified' }
AGPMappingStrategy class >> linkingStrategy [
	^ AGPLinkingPlotStrategy new  
]

{ #category : #testing }
AGPMappingStrategy >> afterApply [ 	
	" "
]

{ #category : #testing }
AGPMappingStrategy >> applyInto: anAlceGraphPlotter forRelationFrom: anEntity to: destination [
	^ self subclassResponsibility 
	
]

{ #category : #testing }
AGPMappingStrategy >> beforeApply [ 	
	" "
]
