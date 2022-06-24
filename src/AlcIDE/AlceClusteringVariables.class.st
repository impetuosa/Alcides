Class {
	#name : #AlceClusteringVariables,
	#superclass : #AlceClustering,
	#instVars : [
		'traversed',
		'processingFunction'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #visiting }
AlceClusteringVariables >> initialize [

	super initialize.
	traversed := Set new
]

{ #category : #visiting }
AlceClusteringVariables >> isInterestingEntity: anEntity contextType: anUserType [

	anEntity candidate isUnknownOrUndefined ifTrue: [ ^ false ].
	(anEntity candidate isKindOf: AlcixReference) ifTrue: [ ^ false ].
	(anEntity candidate isKindOf: AlcixLiteral) ifTrue: [ ^ false ].
	anEntity candidate isUnknown ifTrue: [ ^ false ].
	anEntity candidate isParameter ifTrue: [ ^ false ].
	anEntity candidate isLocalVariable ifTrue: [ ^ false ].
	anEntity candidate type isUnknownOrUndefined ifTrue: [ ^ false ].
	(anEntity candidate isKindOf: AlcixConstant) ifTrue: [ 
		^ (anEntity candidate owner = anUserType) not ].
	^ true
]

{ #category : #visiting }
AlceClusteringVariables >> registerAllInterestignChildsFrom: aCollection function: aFn as: aRelation [

	(aCollection select: [ :a | 
		 self isInterestingEntity: a contextType: aFn userType ]) do: [ :ra | 
		(ra candidate isKindOf: AlcixAssignment)
			ifTrue: [ 
				self
					registerAllInterestignChildsFrom: ra candidate readElements
					function: aFn
					as: aRelation ]
			ifFalse: [ 
				self register: ra candidate architecturalRole: ra candidate type.
				self object: aFn relatesAs: aRelation with: ra candidate ] ]
]

{ #category : #visiting }
AlceClusteringVariables >> shouldAdd: anAlcixSubProcedure [

	(anAlcixSubProcedure outgoingReadAccesses anySatisfy: [ :a | 
		 self isInterestingEntity: a contextType: anAlcixSubProcedure ]) 
		ifTrue: [ ^ true ].
	^ anAlcixSubProcedure assignments anySatisfy: [ :a | 
		  self
			  isInterestingEntity: a writeElement first
			  contextType: anAlcixSubProcedure userType ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitAccess: anAlcixAccess [

	(self
		 isInterestingEntity: anAlcixAccess
		 contextType: processingFunction userType) ifTrue: [ 
		self
			register: anAlcixAccess candidate
			architecturalRole: anAlcixAccess candidate type.
		self
			object: processingFunction
			relatesAs: 'reads'
			with: anAlcixAccess candidate ].

	self visitCollection: anAlcixAccess arguments
]

{ #category : #visiting }
AlceClusteringVariables >> visitAttribute: anAlcixAttribute [

	self
		register: anAlcixAttribute
		architecturalRole: anAlcixAttribute type 
		
]

{ #category : #visiting }
AlceClusteringVariables >> visitConstant: anAlcixConstant [

	self
		register: anAlcixConstant
		architecturalRole: anAlcixConstant type
		
]

{ #category : #visiting }
AlceClusteringVariables >> visitInvocation: anAlcixInvocation [ 
	self visitCollection: anAlcixInvocation arguments 
]

{ #category : #visiting }
AlceClusteringVariables >> visitModule: anAlcixModule [

	self register: anAlcixModule architecturalRole: anAlcixModule.
	anAlcixModule members do: [ :m | 
		m accept: self ].
	anAlcixModule constants do: [ :m | 
		m accept: self ].
	anAlcixModule invocables do: [ :m | 
		m accept: self ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitSubProcedure: anAlcixSubProcedure [

	processingFunction := anAlcixSubProcedure.
	(self shouldAdd: anAlcixSubProcedure) ifFalse: [ ^ self ].
	self
		register: anAlcixSubProcedure
		architecturalRole: anAlcixSubProcedure userType.

	self
		registerAllInterestignChildsFrom:
		anAlcixSubProcedure outgoingReadAccesses
		function: anAlcixSubProcedure
		as: #reads.

	(anAlcixSubProcedure assignments select: [ :a | 
		 self
			 isInterestingEntity: a writeElement first
			 contextType: anAlcixSubProcedure userType ]) do: [ :ra | 
		self
			registerAllInterestignChildsFrom: ra writeElement
			function: anAlcixSubProcedure
			as: #writes.
		self
			registerAllInterestignChildsFrom: ra readElements
			function: anAlcixSubProcedure
			as: #reads ].

	anAlcixSubProcedure outgoingInvocations do: [ :p | p accept: self ]
]
