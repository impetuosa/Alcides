Class {
	#name : #SpDragHere,
	#superclass : #SpContainerPresenter,
	#instVars : [
		'dropInto'
	],
	#category : #'AlcIDE-Spec'
}

{ #category : #specs }
SpDragHere class >> adapterName [ 
	 ^ #SpMorphicDragHereAdapter
]

{ #category : #'changing suspended state' }
SpDragHere >> dropInto: aDropIn [

	dropInto := aDropIn
]

{ #category : #testing }
SpDragHere >> hasLeft: anAlceSourceCodeWidget [

	dropInto hasLeft: anAlceSourceCodeWidget
]

{ #category : #'changing suspended state' }
SpDragHere >> install: aPresenter [

	^ dropInto install: aPresenter
]
