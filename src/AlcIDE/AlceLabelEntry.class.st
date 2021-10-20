Class {
	#name : #AlceLabelEntry,
	#superclass : #SpPresenter,
	#instVars : [
		'label'
	],
	#category : #'AlcIDE-Menu'
}

{ #category : #specs }
AlceLabelEntry class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
		
				   add: #label withConstraints: [ :constraints | constraints width: 75; padding: 10 ] ;
				   yourself)
		  withConstraints: [ :constraints | constraints height: 60; padding: 23 ] 
]

{ #category : #initialization }
AlceLabelEntry >> initializePresenter [

	super initializePresenter.
	label := self newLabel
]

{ #category : #initialization }
AlceLabelEntry >> label: aLabel [ 
	label label: aLabel
]
