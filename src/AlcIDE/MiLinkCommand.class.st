Class {
	#name : #MiLinkCommand,
	#superclass : #CmCommand,
	#category : #'AlcIDE-Commands'
}

{ #category : #default }
MiLinkCommand class >> defaultDescription [
	^ 'Launch linking algorithm'
]

{ #category : #default }
MiLinkCommand class >> defaultName [
	^ 'Link'
]

{ #category : #default }
MiLinkCommand class >> forSpecContext: anObject [
	^ (super forSpecContext: anObject)
		iconNamed: #mooseIcon;
		beHiddenWhenCantBeRun;
		yourself
]

{ #category : #testing }
MiLinkCommand >> canBeExecuted [

	^ self context miSelectedItem isMooseObject and: [ self context miSelectedItem isKindOf: AlcixContainer  ]
]

{ #category : #testing }
MiLinkCommand >> execute [
	AlceLinker link: self context miSelectedItem tries: 1 
]
