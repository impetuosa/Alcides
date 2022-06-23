"
My instances put events on a shape, when this shapes moves it will be on top of the visualization
"
Class {
	#name : #GraphOnTopWhenPositionChanged,
	#superclass : #RSInteraction,
	#category : #'AlcIDE-Clustering'
}

{ #category : #hooks }
GraphOnTopWhenPositionChanged >> moveToTop: evt [

	| shape |
	evt shape: evt shape parent. 
	shape := evt shape.
	shape ifNil: [ ^ self ].
	shape isInACanvas ifFalse: [ ^ self ].
	shape pushFront.
	(shape withAllChildren flatCollect: #connectedLines) do: #pushFront
]

{ #category : #hooks }
GraphOnTopWhenPositionChanged >> onShape: aShape [
	aShape
		when: RSPositionChangedEvent 
		send: #moveToTop:
		to: self
]
