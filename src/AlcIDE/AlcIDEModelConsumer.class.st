Class {
	#name : #AlcIDEModelConsumer,
	#superclass : #Object,
	#instVars : [
		'updateServiceCaller',
		'updateModelSubscription',
		'model',
		'version',
		'modelName'
	],
	#category : #AlcIDE
}

{ #category : #'as yet unclassified' }
AlcIDEModelConsumer >> modelName: aString [ 
	modelName := aString 
]

{ #category : #'as yet unclassified' }
AlcIDEModelConsumer >> updateModel: aVersionedModelMessage [
	self halt
]

{ #category : #accessing }
AlcIDEModelConsumer >> updateModelSubscription: aMDDSSubscription [ 
	updateModelSubscription := aMDDSSubscription
]

{ #category : #accessing }
AlcIDEModelConsumer >> updateServiceCaller: aDDSServiceCaller [ 
	updateServiceCaller := aDDSServiceCaller
]
