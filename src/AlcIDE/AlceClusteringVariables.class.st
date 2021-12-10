Class {
	#name : #AlceClusteringVariables,
	#superclass : #Object,
	#instVars : [
		'mooseModel',
		'graph'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #accessing }
AlceClusteringVariables >> graph [
	^ graph ifNil: [ graph := GTEIndexedAdjacencyListGraph new ]
]

{ #category : #accessing }
AlceClusteringVariables >> mooseModel: anAlcixModel [

	mooseModel := anAlcixModel.
	mooseModel selectedColoringStrategy selectingCategory markedTags do: [ 
		:t | t accept: self ]
]

{ #category : #'as yet unclassified' }
AlceClusteringVariables >> object: anAlcixModule relatesAs: aString with: anAlceTagAssociationWrapDueTo [

	| from to |
	from := self graph addAndRefer: anAlcixModule.
	to := self graph addAndRefer: anAlceTagAssociationWrapDueTo.
	self graph addArc: (GTEDirectedNamedArc new
			 name: aString asSymbol;
			 from: from;
			 to: to;
			 yourself)
]

{ #category : #'as yet unclassified' }
AlceClusteringVariables >> register:anAlcixAttribute architecturalRole: aType [ 

	self
		object: anAlcixAttribute
		relatesAs: #architecturalRole
		with: (self tagFor: aType)
]

{ #category : #'as yet unclassified' }
AlceClusteringVariables >> tagFor: anAlcixModule [

	| tags |
	tags := ((mooseModel selectedColoringStrategy verticalColor 
		          colorsFor: anAlcixModule) collect: #tag) asSet.
	tags size = 1 ifTrue: [ ^ tags anyOne ].
	tags size = 0 ifTrue: [ 
		^ mooseModel selectedColoringStrategy selectingCategory markedTags 
			  detect: [ :t | t name = 'Business' ] ].


	^ tags detect: [ :t | (t name = 'Business') not ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitAccessModule: anAlcixAccessModule [

	self
		register: anAlcixAccessModule
		architecturalRole: anAlcixAccessModule.
	anAlcixAccessModule types do: [ :t | 
		self object: t relatesAs: #belongsTo with: anAlcixAccessModule.
		t accept: self ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitAccessProject: anAlcixAccessProject [

	anAlcixAccessProject modules do: [ :t | 
		self object: t relatesAs: #belongsTo with: anAlcixAccessProject.
		t accept: self ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitAttribute: anAlcixAttribute [

	self
		register: anAlcixAttribute
		architecturalRole: anAlcixAttribute type 
		
]

{ #category : #visiting }
AlceClusteringVariables >> visitAttributeAccessor: anAlcixAttributeAccessor [

	self visitFunction: anAlcixAttributeAccessor
]

{ #category : #visiting }
AlceClusteringVariables >> visitClass: anAlcixClass [

	self visitModule: anAlcixClass
]

{ #category : #visiting }
AlceClusteringVariables >> visitConstant: anAlcixConstant [

	self
		register: anAlcixConstant
		architecturalRole: anAlcixConstant type
		
]

{ #category : #visiting }
AlceClusteringVariables >> visitEvent: anAlcixEvent [

	self visitFunction: anAlcixEvent
]

{ #category : #visiting }
AlceClusteringVariables >> visitExternalFunction: anAlcixExternalFunction [

	self visitFunction: anAlcixExternalFunction
]

{ #category : #visiting }
AlceClusteringVariables >> visitExternalSubProcedure: anAlcixExternalSubProcedure [

	self visitSubProcedure: anAlcixExternalSubProcedure
]

{ #category : #visiting }
AlceClusteringVariables >> visitFamixTag: aFamixTag [

	self
		object: aFamixTag
		relatesAs: #architecturalColor
		with: aFamixTag color
]

{ #category : #visiting }
AlceClusteringVariables >> visitForm: anAlcixReport [

	self visitModule: anAlcixReport
]

{ #category : #visiting }
AlceClusteringVariables >> visitFunction: anAlcixFunction [

	self visitSubProcedure: anAlcixFunction
]

{ #category : #visiting }
AlceClusteringVariables >> visitLocalVariable: anAlcixLocalVariable [

	self
		register: anAlcixLocalVariable
		architecturalRole: anAlcixLocalVariable type
]

{ #category : #visiting }
AlceClusteringVariables >> visitModel: anAlcixModel [
	anAlcixModel project accept: self
]

{ #category : #visiting }
AlceClusteringVariables >> visitModule: anAlcixModule [

	
	self
		register: anAlcixModule
		architecturalRole: anAlcixModule .
	anAlcixModule members do: [ :m | 
		self object: m relatesAs: #belongsTo with: anAlcixModule.
		m accept: self ].
	anAlcixModule constants do: [ :m | 
		self object: m relatesAs: #belongsTo with: anAlcixModule.
		m accept: self ].
	anAlcixModule invocables do: [ :m | 
		self object: m relatesAs: #belongsTo with: anAlcixModule.
		m accept: self ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitParameter: anAlcixParameter [

	self
		register: anAlcixParameter
		architecturalRole: anAlcixParameter type

]

{ #category : #visiting }
AlceClusteringVariables >> visitQuery: anAlcixQuery [

	self visitTable: anAlcixQuery
]

{ #category : #visiting }
AlceClusteringVariables >> visitReport: anAlcixReport [

	self visitModule: anAlcixReport
]

{ #category : #visiting }
AlceClusteringVariables >> visitSubProcedure: anAlcixSubProcedure [

	self
		register: anAlcixSubProcedure
		architecturalRole: anAlcixSubProcedure userType.
	anAlcixSubProcedure localVariables , anAlcixSubProcedure constants
	, anAlcixSubProcedure parameters do: [ :p | 
		self object: p relatesAs: #belongsTo with: anAlcixSubProcedure.
		p accept: self ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitTable: anAlcixTable [

	self register: anAlcixTable architecturalRole: anAlcixTable.


	anAlcixTable members do: [ :m | 
		self object: m relatesAs: #belongsTo with: anAlcixTable.
		m accept: self ]
]

{ #category : #visiting }
AlceClusteringVariables >> visitTableField: anAlcixTableField [

	self visitAttribute: anAlcixTableField
]
