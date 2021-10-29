Class {
	#name : #AlceGraphMapper,
	#superclass : #Object,
	#instVars : [
		'graph',
		'mappeEntities',
		'doNotMapBlock',
		'entityMappingRules',
		'defaultEntityBuilder',
		'relationMappingRules'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #'as yet unclassified' }
AlceGraphMapper >> applyRelationRepresentations [
	relationMappingRules do: [ :rule | rule beforeApply ].
	graph nodes do: [ :node | 
		relationMappingRules do: [ :rule | 
			rule buildRepresentationFor: node into: self ] ].
	
]

{ #category : #'as yet unclassified' }
AlceGraphMapper >> defaultEntityBuilder: aFullBlockClosure [

	defaultEntityBuilder := aFullBlockClosure
]

{ #category : #'as yet unclassified' }
AlceGraphMapper >> defaultEntityMapperBlock [

	^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
AlceGraphMapper >> doNotMap: aFullBlockClosure [ 
	doNotMapBlock := aFullBlockClosure
]

{ #category : #accessing }
AlceGraphMapper >> entityMappingRules [
	^ entityMappingRules
]

{ #category : #accessing }
AlceGraphMapper >> finalize [

	mappeEntities := nil.
	graph := nil.
	entityMappingRules := nil. 
	relationMappingRules := nil.

]

{ #category : #accessing }
AlceGraphMapper >> graph [
	^ graph
]

{ #category : #accessing }
AlceGraphMapper >> graph: aGTEIndexedAdjacencyListGraph [

	graph := aGTEIndexedAdjacencyListGraph
]

{ #category : #accessing }
AlceGraphMapper >> initialize [

	super initialize.
	defaultEntityBuilder := self defaultEntityMapperBlock.
	entityMappingRules := Set new.
	relationMappingRules := Set new.
	entityMappingRules := Set new
]

{ #category : #accessing }
AlceGraphMapper >> mapAllNodes [

	mappeEntities := graph nodes
		                 reject: [ :e | doNotMapBlock value: e ]
		                 thenCollect: [ :n | self mapEntity: n ]
]

{ #category : #accessing }
AlceGraphMapper >> mapEntity: anEntity [

	^ (entityMappingRules
		   detect: [ :rule | rule matches: anEntity ]
		   ifNone: [ self defaultEntityMapperBlock ]) value: anEntity
]

{ #category : #removing }
AlceGraphMapper >> removeMappedEntity: aRSComposite [

	mappeEntities remove: aRSComposite 
]

{ #category : #'as yet unclassified' }
AlceGraphMapper >> representRelationNamed: aString with: anAGPContainancePlotStrategy [

	relationMappingRules add: (AGPMappingRelationRule new
			 arcName: aString;
			 strategy: anAGPContainancePlotStrategy;
			 yourself)
]

{ #category : #'as yet unclassified' }
AlceGraphMapper >> representReverseRelationNamed: aString with: anAGPContainancePlotStrategy [ 
	relationMappingRules add: (AGPReverseMappingRelationRule new
			 arcName: aString;
			 strategy: anAGPContainancePlotStrategy;
			 yourself)
]

{ #category : #'as yet unclassified' }
AlceGraphMapper >> whenEntity: aFullBlockClosure buildShapeWith: aFullBlockClosure2 [

	self entityMappingRules add: (AGPShapeRule new
			 condition: aFullBlockClosure;
			 buildingBlock: aFullBlockClosure2;
			 yourself)
]
