Class {
	#name : #AlceSourceCodePropagator,
	#superclass : #Object,
	#instVars : [
		'reladtedWidget'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #opening }
AlceSourceCodePropagator >> browse: anAlcixLiteral [

	anAlcixLiteral isCollection
		ifFalse: [ anAlcixLiteral accept: self ]
		ifTrue: [ self visitCollection: anAlcixLiteral ]
]

{ #category : #'as yet unclassified' }
AlceSourceCodePropagator >> relatedWidget: anAlceSourceCodeWidget [

	reladtedWidget := anAlceSourceCodeWidget
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitAccess: anAlcixAccess [

	self visitCollection: anAlcixAccess candidates
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitAccessEntity: anAlcixClass [

	reladtedWidget selection: anAlcixClass anchor
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitAccessModule: anAlcixAccessModule [

	reladtedWidget selection: anAlcixAccessModule
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitAlias: anAlcixAlias [ 
	anAlcixAlias type accept: self 
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitAttribute: anAlcixAttribute [
	anAlcixAttribute userType accept: self . 
	self visitAccessEntity: anAlcixAttribute
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitAttributeAccessor: anAlcixAttributeAccessor [

	self visitFunction: anAlcixAttributeAccessor
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitClass: anAlcixClass [

	self visitType: anAlcixClass
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitCollection: aCollection [ 
	^ aCollection collect: [ : a | a accept: self  ]
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitConstant: anAlcixConstant [

	anAlcixConstant owner accept: self.
	self visitAccessEntity: anAlcixConstant
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitEnum: anAlcixEnum [

	self visitType: anAlcixEnum
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitEnumValue: anAlcixEnumValue [

	anAlcixEnumValue enum accept: self.
	self visitAccessEntity: anAlcixEnumValue
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitExternalFunction: anAlcixExternalFunction [

	self visitFunction: anAlcixExternalFunction
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitForm: anAlcixForm [

	self visitClass: anAlcixForm
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitFunction: anAlcixFunction [ 
	anAlcixFunction userType accept: self .
	reladtedWidget selection: anAlcixFunction.
	self visitAccessEntity: anAlcixFunction.
	
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitInvocation: anAlcixInvocation [

	self visitCollection: anAlcixInvocation candidates
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitLibrary: anAlcixLibrary [

	reladtedWidget selection: anAlcixLibrary
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitLiteral: anAlcixLiteral [ 

]

{ #category : #visiting }
AlceSourceCodePropagator >> visitLocalVariable: anAlcixLocalVariable [

	self visitAccessEntity: anAlcixLocalVariable
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitModule: anAlcixModule [

	self visitType: anAlcixModule
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitParameter: anAlcixParameter [

	self visitAccessEntity: anAlcixParameter
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitPrimitiveType: anAlcixPrimitiveType [ 

]

{ #category : #visiting }
AlceSourceCodePropagator >> visitSubProcedure: anAlcixSubProcedure [

	self visitFunction: anAlcixSubProcedure
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitType: anAlcixClass [

	anAlcixClass container accept: self.
	reladtedWidget selection: anAlcixClass.
	self visitAccessEntity: anAlcixClass
]

{ #category : #visiting }
AlceSourceCodePropagator >> visitUnknownElement: anAlcixUnknownElement [ 

]

{ #category : #visiting }
AlceSourceCodePropagator >> visitUserType: anAlcixUserType [ 
	anAlcixUserType container accept: self 
]
