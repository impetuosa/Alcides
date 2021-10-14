Class {
	#name : #AlceElementToString,
	#superclass : #Object,
	#category : #'AlcIDE-Text '
}

{ #category : #'instance creation' }
AlceElementToString >> toString: anEntity [
  
	[ ^ anEntity accept: self ]
		on: Error 
		do: [ :e | self haltOnce ]
]

{ #category : #visiting }
AlceElementToString >> visitAccess: anAlcixAccess [ 
	 ^ anAlcixAccess candidate name 
]

{ #category : #visiting }
AlceElementToString >> visitAccessModule: anAlcixAccessModule [

	^ anAlcixAccessModule name
]

{ #category : #visiting }
AlceElementToString >> visitAlias: anAlcixClass [

	^ anAlcixClass name , ' -> '
	  , anAlcixClass type name adaptToAlceAnchorPathFragment
]

{ #category : #visiting }
AlceElementToString >> visitArgument: anAlcixArgument [ 
	^ anAlcixArgument value 
]

{ #category : #visiting }
AlceElementToString >> visitAssignment: anAlcixAssignment [

	^ (String space join:
		   (anAlcixAssignment writeElement collect: [ :a | a accept: self ]))
	  , '=' , (String space join:
		   (anAlcixAssignment readElements collect: [ :a | a accept: self ]))
]

{ #category : #visiting }
AlceElementToString >> visitAssociation: anAssoc [

	anAssoc key isString ifTrue: [ ^ anAssoc key ].
	^ anAssoc key accept: self
]

{ #category : #visiting }
AlceElementToString >> visitAttribute: anAlcixAttribute [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: anAlcixAttribute name;
			  space;
			  nextPutAll: ':';
			  space;
			  nextPutAll: anAlcixAttribute type name ]
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
AlceElementToString >> visitConstant: anAlcixConstant [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: anAlcixConstant name;
			  space;
			  nextPutAll: ':';
			  space;
			  nextPutAll: anAlcixConstant type name;
			  space;
			  nextPutAll: '=';
			  space;
			  nextPutAll: anAlcixConstant value asString ]
]

{ #category : #visiting }
AlceElementToString >> visitEnum: anEnum [ 

	^ anEnum name
]

{ #category : #visiting }
AlceElementToString >> visitEnumValue: anEnumValue [

	^ anEnumValue name , '=' , anEnumValue value asString
]

{ #category : #visiting }
AlceElementToString >> visitEvent: anEvent [ 
	 ^ self visitInvocable: anEvent 
]

{ #category : #visiting }
AlceElementToString >> visitExternalFunction: anAlcixExternalFunction [ 
	^( self visitFunction:  anAlcixExternalFunction ), ' (External) '
]

{ #category : #visiting }
AlceElementToString >> visitExternalSubProcedure: anAlcixExternalSubProcedure [

	^ (self visitSubProcedure: anAlcixExternalSubProcedure) , ' (External) '
]

{ #category : #visiting }
AlceElementToString >> visitForm: anAlcixClass [

	^ self visitModule: anAlcixClass
]

{ #category : #visiting }
AlceElementToString >> visitFunction: anAlcixFunction [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: (self visitInvocable: anAlcixFunction);
			  space;
			  nextPutAll: ':';
			  space;
			  nextPutAll: (anAlcixFunction type name) ]
]

{ #category : #visiting }
AlceElementToString >> visitGlobalVariable: aVar [

	^(self visitAttribute: aVar), '(global)'
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
AlceElementToString >> visitInvocation: anAlcixInvocation [

	^ anAlcixInvocation name
]

{ #category : #visiting }
AlceElementToString >> visitLibrary: anAlcixLibrary [

	^ anAlcixLibrary name
]

{ #category : #visiting }
AlceElementToString >> visitLiteral: anAlcixLiteral [ 
	 ^ anAlcixLiteral value asString 
]

{ #category : #visiting }
AlceElementToString >> visitLocalVariable: aVar [

	^  (self visitAttribute: aVar), '(local)'
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
AlceElementToString >> visitQuery: anAlcixQuery [

	^ self visitTable: anAlcixQuery
]

{ #category : #visiting }
AlceElementToString >> visitReport: anAlcixClass [

	^ self visitModule: anAlcixClass
]

{ #category : #visiting }
AlceElementToString >> visitReturn: anAlcixReturn [

	^ 'set to return ' , (String space join:
		   (anAlcixReturn outgoingAccesses collect: [ :a | a accept: self ]))
]

{ #category : #visiting }
AlceElementToString >> visitStructure: anAlcixStructure [

	^ self visitUserType: anAlcixStructure
]

{ #category : #visiting }
AlceElementToString >> visitSubProcedure: anAlcixSubProcedure [

	^ self visitInvocable: anAlcixSubProcedure
]

{ #category : #visiting }
AlceElementToString >> visitTable: anAlcixTable [

	^ anAlcixTable name , '(' , anAlcixTable members asOrderedCollection removeDuplicates size asString , ')'
]

{ #category : #visiting }
AlceElementToString >> visitTableField: anAlcixTableField [

	^ anAlcixTableField name, String tab, String tab, anAlcixTableField type name , '('
	  , anAlcixTableField size asString , ') ' 
]

{ #category : #visiting }
AlceElementToString >> visitUnknownElement: anAlcixUnknownElement [ 
	 ^ #Unknown 
]

{ #category : #visiting }
AlceElementToString >> visitUserType: anAlcixUserType [ 
	 ^ anAlcixUserType name 
]
