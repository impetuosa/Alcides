Class {
	#name : #AlceElementToString,
	#superclass : #Object,
	#category : #'AlcIDE-Text '
}

{ #category : #'instance creation' }
AlceElementToString >> toString: anEntity [
[
	^ anEntity accept: self
	] on: Error do:[ self haltOnce  ]
]

{ #category : #visiting }
AlceElementToString >> visitAccessModule: anAlcixAccessModule [

	^ anAlcixAccessModule name
]

{ #category : #visiting }
AlceElementToString >> visitAlias: anAlcixClass [

	^ anAlcixClass name , ' -> '
	  , anAlcixClass typeName adaptToAlceAnchorPathFragment
]

{ #category : #visiting }
AlceElementToString >> visitAssociation: anAssoc [

	anAssoc key isString ifTrue: [ ^ anAssoc key ].
	^ anAssoc key accept: self
]

{ #category : #visiting }
AlceElementToString >> visitAttribute: anAlcixAttribute [

	^ (anAlcixAttribute typeName
		   ifNil: [ 'Unknown' ]
		   ifNotNil: [ :r | r adaptToAlceAnchorPathFragment ]) , ' '
	  , anAlcixAttribute name
]

{ #category : #visiting }
AlceElementToString >> visitAttributeAccessor: anAlcixAttributeAccessor [

	^ self visitFunction: anAlcixAttributeAccessor
]

{ #category : #visiting }
AlceElementToString >> visitClass: anAlcixClass [

	^ self visitModule: anAlcixClass
]

{ #category : #visiting }
AlceElementToString >> visitEnum: anEnum [ 

	^ anEnum name
]

{ #category : #visiting }
AlceElementToString >> visitEnumValue: anEnumValue [

	^ anEnumValue name , '=' , anEnumValue Value asString
]

{ #category : #visiting }
AlceElementToString >> visitEvent: anEvent [ 
	 ^ self visitInvocable: anEvent 
]

{ #category : #visiting }
AlceElementToString >> visitForm: anAlcixClass [

	^ self visitModule: anAlcixClass
]

{ #category : #visiting }
AlceElementToString >> visitFunction: anAlcixFunction [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: (anAlcixFunction typeName
					   ifNil: [ '' ]
					   ifNotNil: [ :e | e adaptToAlceAnchorPathFragment ]);
			  space;
			  nextPutAll: (self visitInvocable: anAlcixFunction) ]
]

{ #category : #visiting }
AlceElementToString >> visitGlobalVariable: aVar [

	^ 'global ' , (self visitAttribute: aVar)
]

{ #category : #visiting }
AlceElementToString >> visitInvocable: anAlcixFunction [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: anAlcixFunction selector;
			  nextPut: $(;
			  nextPutAll: (', ' join:
						   (anAlcixFunction parameters collect: [ :p | p accept: self ]));
			  nextPut: $) ]
]

{ #category : #visiting }
AlceElementToString >> visitLibrary: anAlcixLibrary [

	^ anAlcixLibrary name
]

{ #category : #visiting }
AlceElementToString >> visitLocalVariable: aVar [

	^ 'local ' , (self visitAttribute: aVar)
]

{ #category : #visiting }
AlceElementToString >> visitModule: anAlcixClass [ 
	 ^ anAlcixClass name 
]

{ #category : #visiting }
AlceElementToString >> visitParameter: anAlcixParameter [

	^ 'parameter ' , (self visitAttribute: anAlcixParameter)
]

{ #category : #visiting }
AlceElementToString >> visitPrimitiveType: aType [

	^ aType name
]

{ #category : #visiting }
AlceElementToString >> visitReport: anAlcixClass [

	^ self visitModule: anAlcixClass
]

{ #category : #visiting }
AlceElementToString >> visitSubProcedure: anAlcixSubProcedure [

	^ self visitInvocable: anAlcixSubProcedure
]

{ #category : #visiting }
AlceElementToString >> visitUserType: anAlcixUserType [ 
	 ^ anAlcixUserType name 
]
