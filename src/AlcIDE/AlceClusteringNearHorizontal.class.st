Class {
	#name : #AlceClusteringNearHorizontal,
	#superclass : #AlceClusteringVariables,
	#category : #'AlcIDE-Clustering'
}

{ #category : #visiting }
AlceClusteringNearHorizontal >> registerAllInterestignChildsFrom: aCollection function: aFn as: aRelation [

	(aCollection select: [ :a | 
		 self isInterestingEntity: a contextType: aFn userType ]) do: [ :ra | 
		(ra candidate isKindOf: AlcixAssignment)
			ifTrue: [ 
				self
					registerAllInterestignChildsFrom: ra candidate readElements
					function: aFn
					as: aRelation ]
			ifFalse: [ 
				self
					register: ra candidate type
					architecturalRole: ra candidate type.
				self object: aFn relatesAs: aRelation with: ra candidate type ] ]
]

{ #category : #visiting }
AlceClusteringNearHorizontal >> visitAccess: anAlcixAccess [

	(self
		 isInterestingEntity: anAlcixAccess
		 contextType: processingFunction userType) ifTrue: [ 
		self
			register: anAlcixAccess candidate type
			architecturalRole: anAlcixAccess candidate type.
		self
			object: processingFunction
			relatesAs: 'reads'
			with: anAlcixAccess candidate type ].

	self visitCollection: anAlcixAccess arguments
]

{ #category : #visiting }
AlceClusteringNearHorizontal >> visitAttribute: anAlcixAttribute [

]

{ #category : #visiting }
AlceClusteringNearHorizontal >> visitConstant: anAlcixConstant [

]

{ #category : #visiting }
AlceClusteringNearHorizontal >> visitInvocation: anAlcixInvocation [

	| firstCallingInvocable |
	firstCallingInvocable := anAlcixInvocation withAccesses.
	(firstCallingInvocable isKindOf: AlcixArgument) ifTrue: [ 
		firstCallingInvocable := firstCallingInvocable activation
			                         withAccesses ].

	self assert: anAlcixInvocation candidates size = 1.

	(self tagFor: anAlcixInvocation candidates first) name = #Language 
		ifTrue: [ ^ self ].

	processingFunction userType
	= anAlcixInvocation candidates first userType ifFalse: [ 
		self
			object: firstCallingInvocable
			relatesAs: #activates
			with: anAlcixInvocation candidates first ].
	self
		register: anAlcixInvocation candidates first
		architecturalRole: anAlcixInvocation candidates first userType.
	self visitCollection: anAlcixInvocation arguments
]
