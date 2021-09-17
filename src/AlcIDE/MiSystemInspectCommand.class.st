Class {
	#name : #MiSystemInspectCommand,
	#superclass : #CmCommand,
	#category : #'AlcIDE-Commands'
}

{ #category : #default }
MiSystemInspectCommand class >> defaultDescription [
	^ 'Pharo-Inspect selected entity'
]

{ #category : #default }
MiSystemInspectCommand class >> defaultName [

	^ 'Inspect'
]

{ #category : #default }
MiSystemInspectCommand class >> forSpecContext: anObject [
	^ (super forSpecContext: anObject)
		iconNamed: #mooseIcon;
		beHiddenWhenCantBeRun;
		yourself
]

{ #category : #executing }
MiSystemInspectCommand >> execute [

	self context miSelectedItem inspect
]
