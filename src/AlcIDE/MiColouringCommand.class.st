Class {
	#name : #MiColouringCommand,
	#superclass : #CmCommand,
	#category : #'AlcIDE-Commands'
}

{ #category : #default }
MiColouringCommand class >> defaultDescription [
	^ 'Change selected entity colour'
]

{ #category : #default }
MiColouringCommand class >> defaultName [
	^ 'Colouring'
]

{ #category : #default }
MiColouringCommand class >> forSpecContext: anObject [
	^ (super forSpecContext: anObject)
		iconNamed: #mooseIcon;
		beHiddenWhenCantBeRun;
		yourself
]

{ #category : #testing }
MiColouringCommand >> canBeExecuted [

	^ self context miSelectedItem isMooseObject or: [ 
		  self context miSelectedItem isCollection and: [ 
			  self context miSelectedItem allSatisfy: #isMooseObject ] ]
]

{ #category : #executing }
MiColouringCommand >> execute [

	| selectedItems |
	selectedItems := [ self context miSelectedItem asCollection ]
		                 on: MiNoSelectedElementToPropagateException
		                 do: [ :exception | 
			                 exception signal.
			                 ^ self ].

	SpColorPicker new
		selectedColor: selectedItems first color;
		whenColorAccepted: [ :color | 
			selectedItems do: [ :s | s color: color ] ];
		openWithSpec
]
