Class {
	#name : #AlceAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'action',
		'presenter'
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
AlceAction >> initialize [ 
	super initialize .
	presenter := SpButtonPresenter.
]

{ #category : #accessing }
AlceAction >> instantiateElementWith: aSpec [
	^ aSpec instantiate: presenter
]

{ #category : #accessing }
AlceAction >> name [
	^ name
]

{ #category : #accessing }
AlceAction >> name: aString [ 
	name := aString
]

{ #category : #accessing }
AlceAction >> presenter: aPresenterClass [ 
	presenter := aPresenterClass 
]
