Class {
	#name : #GraphResizeParentWhenChildMoves,
	#superclass : #RSResizeParentWhenChildMoves,
	#category : #'AlcIDE-Clustering'
}

{ #category : #hooks }
GraphResizeParentWhenChildMoves >> childrenFor: parent [

	^ parent schildren ifNil: [ {  } ]
]

{ #category : #hooks }
GraphResizeParentWhenChildMoves >> defaultPadding [
	^ 0
]

{ #category : #hooks }
GraphResizeParentWhenChildMoves >> onShape: aCanvas [
	aCanvas isShape 
		ifTrue: [ ^ self registerShape: aCanvas  ].
		
	aCanvas allChildren do: [ :child | self registerShape: child ]
]

{ #category : #hooks }
GraphResizeParentWhenChildMoves >> parentFor: shape [
	^ shape sparent
]

{ #category : #hooks }
GraphResizeParentWhenChildMoves >> prepare: shape with: parent [

	| child boxChildren  rectangle |

	child := shape parent .
	child
		adjustToChildren;
		padding: 10.

	boxChildren := parent children first.

	rectangle := child encompassingRectangle.
	rectangle := rectangle extendBy: rectangle extent * 0.3.
	
	boxChildren fromRectangle: rectangle.
	child position: child encompassingRectangle floatCenter.
	boxChildren position: child encompassingRectangle floatCenter
]
