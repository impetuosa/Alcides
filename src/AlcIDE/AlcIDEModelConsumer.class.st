Class {
	#name : #AlcIDEModelConsumer,
	#superclass : #Object,
	#instVars : [
		'updateServiceCaller',
		'updateModelSubscription',
		'model',
		'version',
		'modelName',
		'modelString'
	],
	#category : #AlcIDE
}

{ #category : #accessing }
AlcIDEModelConsumer >> model [

	^ model ifNil: [ 
		  modelString ifNil: [ ^ self error: 'no model available' ].
		  model := AlcixModel importFromMSEStream: modelString readStream.
		  modelString := nil.
		  model.
		 ]
]

{ #category : #'as yet unclassified' }
AlcIDEModelConsumer >> modelName: aString [ 
	modelName := aString 
]

{ #category : #'as yet unclassified' }
AlcIDEModelConsumer >> updateModel: aVersionedModelMessage [

	(version isNil or: [ version < aVersionedModelMessage version ]) 
		ifTrue: [ 
			modelString := aVersionedModelMessage model.
			model := nil.
			version := aVersionedModelMessage version ]
]

{ #category : #accessing }
AlcIDEModelConsumer >> updateModelSubscription: aMDDSSubscription [ 
	updateModelSubscription := aMDDSSubscription
]

{ #category : #accessing }
AlcIDEModelConsumer >> updateServiceCaller: aDDSServiceCaller [ 
	updateServiceCaller := aDDSServiceCaller
]
