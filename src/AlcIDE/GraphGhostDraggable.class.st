Class {
	#name : #GraphGhostDraggable,
	#superclass : #RSGhostDraggable,
	#category : #'AlcIDE-Clustering'
}

{ #category : #hooks }
GraphGhostDraggable >> createGhost: evt [

	| shapes |
	evt shape: evt shape parent.
	shapes := evt canvas selectedShapes.
	(shapes includes: evt shape)
		ifTrue: [ shapes do: [ :shape | super createGhost: shape ] ]
		ifFalse: [ super createGhost: evt ]
]

{ #category : #hooks }
GraphGhostDraggable >> removeGhost: evt [

	| shapes original |
	original := evt shape. 
	evt shape: evt shape parent.
	shapes := evt canvas selectedShapes.
	(shapes includes: evt shape)
		ifTrue: [ shapes do: [ :shape | super removeGhost: shape  ] ]
		ifFalse: [ super removeGhost: evt ].

	 original announce: [RSPositionChangedEvent new 
		shape: self; 
		oldPosition: original position ;
		newPosition: original position ].

]

{ #category : #hooks }
GraphGhostDraggable >> updateGhost: evt [

	| shapes d |
	evt shape: evt shape parent .
	shapes := evt canvas selectedShapes.
	(shapes includes: evt shape)
		ifTrue: [ 
			shapes do: [ :shape | 
				d := evt camera distanceFromPixelToSpace: evt step.
				(shape parent propertyAt: #ghost) translateBy: d ].
			evt signalUpdate ]
		ifFalse: [ super updateGhost: evt ]
]
