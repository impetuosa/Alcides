Class {
	#name : #AlceGraphPropagateMenuItem,
	#superclass : #HAbstractMenuItem,
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #accessing }
AlceGraphPropagateMenuItem >> execute [

	(shape model respondsTo: #anchor) ifTrue: [ 
		visualization propagate: shape model anchor ].
	visualization propagate: shape model
]

{ #category : #accessing }
AlceGraphPropagateMenuItem >> group [
	^ 100
]

{ #category : #accessing }
AlceGraphPropagateMenuItem >> iconName [
	^ #smallPropagate
]

{ #category : #accessing }
AlceGraphPropagateMenuItem >> label [
	^ 'Propagate'
]

{ #category : #accessing }
AlceGraphPropagateMenuItem >> order [
	^ 100
]
