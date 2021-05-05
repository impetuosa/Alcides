Class {
	#name : #AlcIDEModelConsumer,
	#superclass : #Object,
	#instVars : [
		'updateServiceCaller',
		'updateModelSubscription',
		'model',
		'version'
	],
	#category : #AlcIDE
}

{ #category : #'as yet unclassified' }
AlcIDEModelConsumer >> updateModel: aVersionedModelMessage [
	self halt
]
