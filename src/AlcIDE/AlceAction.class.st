Class {
	#name : #AlceAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'action'
	],
	#category : #'AlcIDE-Menu'
}

{ #category : #accessing }
AlceAction >> action: anAction [ 
	action := anAction 
]

{ #category : #accessing }
AlceAction >> execute [
	^ action value
]

{ #category : #accessing }
AlceAction >> name [
	^ name
]

{ #category : #accessing }
AlceAction >> name: aString [ 
	name := aString
]
