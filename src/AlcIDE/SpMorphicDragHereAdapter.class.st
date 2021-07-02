Class {
	#name : #SpMorphicDragHereAdapter,
	#superclass : #SpMorphicContainerAdapter,
	#instVars : [
		'transferMorph'
	],
	#category : #'AlcIDE-Spec'
}

{ #category : #factory }
SpMorphicDragHereAdapter >> buildWidget [

	^ DragHere new
		  changeProportionalLayout;
		  vResizing: #spaceFill;
		  hResizing: #spaceFill;
		  dragEnabled: self dragEnabled;
		  dropEnabled: self dropEnabled;
		  wantsDroppedMorph: [ :t | self presenter wantsDrop value: t ];
		  acceptDroppingMorph:
			  [ :t | self presenter acceptDrop value: t ] yourself
]
