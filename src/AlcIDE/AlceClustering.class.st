Class {
	#name : #AlceClustering,
	#superclass : #Object,
	#instVars : [
		'mooseModel',
		'graph',
		'registeredElements'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #accessing }
AlceClustering >> graph [
	^ graph ifNil: [ graph := GTEIndexedAdjacencyListGraph new ]
]

{ #category : #visiting }
AlceClustering >> isLanguageElement: aNode [

	^ (((self graph arcsFromObject: aNode)
		    detect: [ :a | a name = #architecturalRole ]
		    ifNone: [ ^ false ]) to readValueFrom: self graph) name = #Language
]

{ #category : #accessing }
AlceClustering >> mooseModel: anAlcixModel [

	mooseModel := anAlcixModel.
	mooseModel selectedColoringStrategy selectingCategory markedTags do: [ 
		:t | t accept: self ]
]

{ #category : #'as yet unclassified' }
AlceClustering >> object: anAlcixModule relatesAs: aString with: anAlceTagAssociationWrapDueTo [

	| from to |
	((anAlceTagAssociationWrapDueTo respondsTo: #isUnknownOrUndefined) 
		 and: [ anAlceTagAssociationWrapDueTo isUnknownOrUndefined ]) 
		ifTrue: [ self halt ].
	from := self graph addAndRefer: anAlcixModule.
	to := self graph addAndRefer: anAlceTagAssociationWrapDueTo.
	self graph addArc: (GTEDirectedNamedArc new
			 name: aString asSymbol;
			 from: from;
			 to: to;
			 yourself)
]

{ #category : #'as yet unclassified' }
AlceClustering >> register: anAlcixAttribute architecturalRole: aType [

	(self registeredElements includes: anAlcixAttribute) ifTrue: [ 
		^ self ].
	self registeredElements add: anAlcixAttribute.
	self
		object: anAlcixAttribute
		relatesAs: #architecturalRole
		with: (self tagFor: aType or: anAlcixAttribute)
]

{ #category : #'as yet unclassified' }
AlceClustering >> registeredElements [

	^ registeredElements ifNil: [ registeredElements := Set new ]
]

{ #category : #'as yet unclassified' }
AlceClustering >> tagFor: anAlcixModule [

	| tags |
	tags := ((mooseModel selectedColoringStrategy verticalColor 
		          colorsFor: anAlcixModule) collect: #tag) asSet.
	tags size = 1 ifTrue: [ ^ tags anyOne ].
	tags size = 0 ifTrue: [ 

		^ mooseModel selectedColoringStrategy selectingCategory markedTags 
			  detect: [ :t | t name = 'Business' ] ].

	^ tags detect: [ :t | (t name = 'Business') not ]
]

{ #category : #'as yet unclassified' }
AlceClustering >> tagFor: anAlcixModule or: anAlcixAttribute [

	| tags |
	tags := ((mooseModel selectedColoringStrategy verticalColor 
		          colorsFor: anAlcixModule) collect: #tag) asSet.
	tags size = 1 ifTrue: [ ^ tags anyOne ].
	tags size = 0 ifTrue: [ ^ self tagFor: anAlcixAttribute ].
	^ tags detect: [ :t | (t name = 'Business') not ]
]

{ #category : #visiting }
AlceClustering >> visitAccessModule: anAlcixAccessModule [

	self
		register: anAlcixAccessModule
		architecturalRole: anAlcixAccessModule.
	anAlcixAccessModule types do: [ :t | 
"		self object: t relatesAs: #belongsTo with: anAlcixAccessModule."
		t accept: self ]
]

{ #category : #visiting }
AlceClustering >> visitAccessProject: anAlcixAccessProject [

	anAlcixAccessProject modules do: [ :t | 
		self object: t relatesAs: #belongsTo with: anAlcixAccessProject.
		t accept: self ]
]

{ #category : #visiting }
AlceClustering >> visitArgument: anAlcixArgument [ 
	self visitCollection: anAlcixArgument outgoingAccesses 
]

{ #category : #visiting }
AlceClustering >> visitAttributeAccessor: anAlcixAttributeAccessor [

	self visitFunction: anAlcixAttributeAccessor
]

{ #category : #visiting }
AlceClustering >> visitClass: anAlcixClass [

	self visitModule: anAlcixClass
]

{ #category : #visiting }
AlceClustering >> visitCollection: aCollection [

	aCollection do: [ :a | a accept: self ]
]

{ #category : #visiting }
AlceClustering >> visitEvent: anAlcixEvent [

	self visitFunction: anAlcixEvent
]

{ #category : #visiting }
AlceClustering >> visitExternalFunction: anAlcixExternalFunction [

	self visitFunction: anAlcixExternalFunction
]

{ #category : #visiting }
AlceClustering >> visitExternalSubProcedure: anAlcixExternalSubProcedure [

	self visitSubProcedure: anAlcixExternalSubProcedure
]

{ #category : #visiting }
AlceClustering >> visitFamixTag: aFamixTag [

	self
		object: aFamixTag
		relatesAs: #architecturalColor
		with: aFamixTag color
]

{ #category : #visiting }
AlceClustering >> visitForm: anAlcixReport [

	self visitModule: anAlcixReport
]

{ #category : #visiting }
AlceClustering >> visitFunction: anAlcixFunction [

	self visitSubProcedure: anAlcixFunction
]

{ #category : #visiting }
AlceClustering >> visitLocalVariable: anAlcixLocalVariable [

	self
		register: anAlcixLocalVariable
		architecturalRole: anAlcixLocalVariable type
]

{ #category : #visiting }
AlceClustering >> visitModel: anAlcixModel [
	anAlcixModel project accept: self
]

{ #category : #visiting }
AlceClustering >> visitParameter: anAlcixParameter [

	self
		register: anAlcixParameter
		architecturalRole: anAlcixParameter type

]

{ #category : #visiting }
AlceClustering >> visitQuery: anAlcixQuery [

	self visitTable: anAlcixQuery
]

{ #category : #visiting }
AlceClustering >> visitReport: anAlcixReport [

	self visitModule: anAlcixReport
]

{ #category : #visiting }
AlceClustering >> visitTable: anAlcixTable [

	self register: anAlcixTable architecturalRole: anAlcixTable.


	anAlcixTable members do: [ :m | 
		self object: m relatesAs: #belongsTo with: anAlcixTable.
		m accept: self ]
]

{ #category : #visiting }
AlceClustering >> visitTableField: anAlcixTableField [

	self visitAttribute: anAlcixTableField
]
