Class {
	#name : #AlcIDEModelProvider,
	#superclass : #Object,
	#instVars : [
		'publication',
		'modelName',
		'modelString',
		'lastVersion',
		'processingFuture'
	],
	#category : #AlcIDE
}

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> forceCodeReload [

	Metacello new
		baseline: 'Alce';
		repository: 'github://impetuosa/Alce';
		onConflictUseIncoming;
		load
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> forceRegenerate [

	AlceNorthwindCachedModelAbstractTest resetNorwindCachedModel.
	AlceNorthwindCachedModelAbstractTest regenerateCacheModel.
	lastVersion := lastVersion + 1
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> loadMSEModel [
	modelString := AlceNorthwindCachedModelAbstractTest cachedModelMSE.
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> modelName: aName [
	modelName := aName
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> processNewVersion [
	self assert: modelName = 'norwind'.
	processingFuture
		ifNotNil: [ processingFuture isFinished
				ifFalse: [ ^ self	"Already processing" ] ].
	processingFuture := [ [ modelString
		ifNil: [ lastVersion := 0 ]
		ifNotNil: [ self forceCodeReload.
			self forceRegenerate ].
	self loadMSEModel.
	self publishModel ]
		ensure: [  ] ] future
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> provide [
	self processNewVersion.
	
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> publication: aPublication [
	publication := aPublication.

]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> publishModel [

	publication publish: [ :versionedModel | 
		versionedModel version: lastVersion.
		versionedModel model: modelString ]
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> updateRequest: aRequest response: aResponse [
	aRequest name = modelName ifFalse: [ 
		aResponse version: -1.
		aResponse errorText: 'This model provider does not provide ' , aRequest name.
		^ aResponse 
	].
	aRequest version < lastVersion ifTrue: [ 
		aResponse version: lastVersion.
			^ aResponse 
	].
	[ 
	   self processNewVersion.
   	   aResponse nextVersion: lastVersion.
	   ^ aResponse 
	]
		on: Error
		do: [ :e | 
			aResponse nextVersion: -1.
			aResponse errorText: ' Error processing new version! ' , e messageText 
		]
]
