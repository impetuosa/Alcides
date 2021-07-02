"
Norwind is a basic publisher aiming to publish the Microsoft Access project through the Hooves network.
"
Class {
	#name : #AlcIDENorwindPublisher,
	#superclass : #HoovesModelPublisher,
	#category : #'AlcIDE-Hooves'
}

{ #category : #accessing }
AlcIDENorwindPublisher class >> description [ 
	^ 'Moose MSE/Json Access Model publisher'
]

{ #category : #accessing }
AlcIDENorwindPublisher class >> isApp [ 
	^ true
]

{ #category : #initialization }
AlcIDENorwindPublisher >> forceCodeReload [
	
	Metacello new
		baseline: 'Alce';
		repository: 'github://impetuosa/Alce';
		onConflictUseIncoming;
		load
]

{ #category : #initialization }
AlcIDENorwindPublisher >> forceRegenerate [

	AlceNorthwindCachedModelAbstractTest resetNorwindCachedModel.
	AlceNorthwindCachedModelAbstractTest regenerateCacheModel.
	version := version + 1
]

{ #category : #initialization }
AlcIDENorwindPublisher >> loadMSEModel [
	modelString := AlceNorthwindCachedModelAbstractTest cachedModelMSE.
]
