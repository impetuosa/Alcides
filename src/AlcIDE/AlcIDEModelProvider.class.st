Class {
	#name : #AlcIDEModelProvider,
	#superclass : #Object,
	#instVars : [
		'publication',
		'modelName',
		'modelString',
		'lastVersion'
	],
	#category : #AlcIDE
}

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> modelName: aName [
	modelName := aName
]

{ #category : #'as yet unclassified' }
AlcIDEModelProvider >> processNewVersion [
	self assert: modelName = 'norwind'.
	modelString
		ifNil: [ lastVersion := 0 ]
		ifNotNil: [ Metacello new
				baseline: 'Alce';
				repository: 'github://impetuosa/Alce';
				onConflictUseIncoming;
				load.
			AlceNorthwindCachedModelAbstractTest resetNorwindCachedModel.
			AlceNorthwindCachedModelAbstractTest regenerateCacheModel.
			lastVersion := lastVersion + 1 ].
	modelString := AlceNorthwindCachedModelAbstractTest cachedModelMSE.
	publication publish: [ : versionedModel |
		versionedModel version: lastVersion. 
		versionedModel model: modelString. 
		 ]
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
AlcIDEModelProvider >> updateRequest: aRequest response: aResponse [
	aRequest name = modelName
		ifFalse: [ aResponse version: -1.
			aResponse
				errorText: 'This model provider does not provide ' , aRequest name.
			^ aResponse ].
	aRequest version < lastVersion
		ifTrue: [ aResponse version: lastVersion.
			^ aResponse ].
	[ self processNewVersion.
	aResponse version: lastVersion.
	^ aResponse ]
		on: Error
		do: [ :e | 
			aResponse version: -1.
			aResponse
				errorText: ' Error processing new version! ' , e messageText ]
]
