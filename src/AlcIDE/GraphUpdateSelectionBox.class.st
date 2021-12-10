Class {
	#name : #GraphUpdateSelectionBox,
	#superclass : #RSInteraction,
	#category : #'AlcIDE-Clustering'
}

{ #category : #hooks }
GraphUpdateSelectionBox >> onShape: aShape [
	aShape
		when: RSPositionChangedEvent 
		send: #updateSelectionBox:
		to: self.
		
]

{ #category : #hooks }
GraphUpdateSelectionBox >> updateSelectionBox: evt [
	| border |
	border := evt shape selectionBox.
	border ifNil: [ ^ self ].
	
	border fromRectangle: evt shape encompassingRectangle.
	border extent: border extent + 4.
]
