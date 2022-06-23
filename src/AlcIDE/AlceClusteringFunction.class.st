Class {
	#name : #AlceClusteringFunction,
	#superclass : #AlceClustering,
	#instVars : [
		'processingFunction'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #visiting }
AlceClusteringFunction >> visitAccess: anAlcixAccess [

	self visitCollection: anAlcixAccess arguments
]

{ #category : #visiting }
AlceClusteringFunction >> visitAttribute: anAlcixAttribute [

]

{ #category : #visiting }
AlceClusteringFunction >> visitConstant: anAlcixConstant [
]

{ #category : #visiting }
AlceClusteringFunction >> visitExternalFunction: anAlcixExternalFunction [

]

{ #category : #visiting }
AlceClusteringFunction >> visitExternalSubProcedure: anAlcixExternalSubProcedure [

]

{ #category : #visiting }
AlceClusteringFunction >> visitInvocation: anAlcixInvocation [

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
		architecturalRole: anAlcixInvocation candidates first userType
]

{ #category : #visiting }
AlceClusteringFunction >> visitModule: anAlcixModule [

	
	self
		register: anAlcixModule
		architecturalRole: anAlcixModule .
	
	anAlcixModule invocables do: [ :m | 
"		self object: m relatesAs: #belongsTo with: anAlcixModule."
		m accept: self ]
]

{ #category : #visiting }
AlceClusteringFunction >> visitSubProcedure: anAlcixSubProcedure [
	processingFunction := anAlcixSubProcedure.
	self
		register: anAlcixSubProcedure
		architecturalRole: anAlcixSubProcedure userType.

	anAlcixSubProcedure outgoingAccesses do: [ :o | 
		self visitCollection: o arguments ].

	anAlcixSubProcedure outgoingInvocations do: [ :p | 
	
		p accept: self ]
]
