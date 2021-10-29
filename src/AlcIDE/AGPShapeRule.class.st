Class {
	#name : #AGPShapeRule,
	#superclass : #Object,
	#instVars : [
		'condition',
		'buildingBlock'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #accessing }
AGPShapeRule >> buildingBlock: aFullBlockClosure [ 
	buildingBlock := aFullBlockClosure
]

{ #category : #accessing }
AGPShapeRule >> condition: aFullBlockClosure [ 
	condition := aFullBlockClosure
]

{ #category : #testing }
AGPShapeRule >> matches: anEntity [ 
	^ condition value: anEntity
]

{ #category : #generated }
AGPShapeRule >> value: anEntity [ 
	^ buildingBlock value: anEntity 
]
