Class {
	#name : #SpDragMe,
	#superclass : #SpButtonPresenter,
	#instVars : [
		'passenger'
	],
	#category : #'AlcIDE-Spec'
}

{ #category : #specs }
SpDragMe class >> adapterName [

	^ #SpMorphicDraggerAdapter
]

{ #category : #accessing }
SpDragMe >> passenger: aSpColorPicker [ 
	passenger := aSpColorPicker
]

{ #category : #'as yet unclassified' }
SpDragMe >> transferPassenger [

	^ SpTransferPresenter new
		  transfer: passenger;
		  from: self;
		  yourself
]
