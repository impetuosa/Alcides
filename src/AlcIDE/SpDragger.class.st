Class {
	#name : #SpDragger,
	#superclass : #SpButtonPresenter,
	#instVars : [
		'passenger'
	],
	#category : #'AlcIDE-Spec'
}

{ #category : #specs }
SpDragger class >> adapterName [

	^ #SpMorphicDraggerAdapter
]

{ #category : #accessing }
SpDragger >> passenger: aSpColorPicker [ 
	passenger := aSpColorPicker
]

{ #category : #'as yet unclassified' }
SpDragger >> transferPassenger [

	^ SpTransferPresenter new
		  transfer: passenger;
		  from: self;
		  yourself
]
