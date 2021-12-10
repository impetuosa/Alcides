Class {
	#name : #HInspectRelations,
	#superclass : #HLineMenuItem,
	#category : #'AlcIDE-Menu'
}

{ #category : #accessing }
HInspectRelations >> execute [

	| allTo result |
	allTo := { shape to model } , shape to model allChildren.
	result := shape from model allDependencies
		          select: [ :a | allTo includes: a to ]
		          thenCollect: [ :a | a from rawModel -> a to rawModel ].
	result inspect
]

{ #category : #accessing }
HInspectRelations >> label [
	^ 'inspect relations'
]
