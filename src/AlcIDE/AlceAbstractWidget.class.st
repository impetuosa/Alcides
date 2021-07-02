Class {
	#name : #AlceAbstractWidget,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'selection',
		'toSelect',
		'browser',
		'drndr'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #commands }
AlceAbstractWidget class >> alceBrowsers [

	^ 'Alce browsers'
]

{ #category : #commands }
AlceAbstractWidget class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [


	rootCommandGroup register:
		(MiAlceInspectCommand forSpecContext: presenterInstance).

	rootCommandGroup register:
		(MiColouringCommand forSpecContext: presenterInstance)
]

{ #category : #commands }
AlceAbstractWidget class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #drndr ;
		  yourself
]

{ #category : #commands }
AlceAbstractWidget class >> helpMessage [
	^ (self comment lines copyUpTo: '')
		fold: [ :s1 :s2 | s1 , Character cr asString , s2 ]
]

{ #category : #commands }
AlceAbstractWidget class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: self alceBrowsers)
		order: 8;
		parent: self midasBrowserMenuLabel.
	(aBuilder item: #openAllAlceBrowsers)
		parent: self alceBrowsers;
		label: 'Open all browsers';
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self allSubclassesDo: #runMe ]
]

{ #category : #commands }
AlceAbstractWidget class >> midasBrowserMenuLabel [
	^ #'Specialized Browsers'
]

{ #category : #commands }
AlceAbstractWidget class >> runMe [

	^ AlceBrowser runMeWith: self
]

{ #category : #accessing }
AlceAbstractWidget >> accept: anEntity [

	self subclassResponsibility
]

{ #category : #opening }
AlceAbstractWidget >> browse: anAlcixLocalVariable [

	(anAlcixLocalVariable respondsTo: #invocable)
		ifTrue: [ 
			selection := anAlcixLocalVariable invocable userType container.
			self propagate.
			selection := anAlcixLocalVariable invocable userType.
			self propagate.
			selection := anAlcixLocalVariable invocable.
			self propagate.
			selection := anAlcixLocalVariable anchor.
			self propagate ]
		ifFalse: [ 
			selection := anAlcixLocalVariable userType container.
			self propagate.
			selection := anAlcixLocalVariable userType.
			self propagate.
			selection := anAlcixLocalVariable.
			self propagate.
			selection := anAlcixLocalVariable anchor ]
]

{ #category : #opening }
AlceAbstractWidget >> browser: aBrowser [
	browser := aBrowser 
]

{ #category : #accessing }
AlceAbstractWidget >> colorForTable: anEntity [

	^ anEntity color
]

{ #category : #actions }
AlceAbstractWidget >> freezeAction [

	^ self
]

{ #category : #opening }
AlceAbstractWidget >> initializePresenters [

	super initializePresenters.
	drndr := self newLabel
		         label: 'drag';
		         dragEnabled: true;
		         yourself.
	self dragEnabled: true
]

{ #category : #testing }
AlceAbstractWidget >> isFollow [
	browser ifNil: [ ^ false ].
	^ browser isFollow
]

{ #category : #testing }
AlceAbstractWidget >> isFreeze [
	 ^ browser ifNotNil: [ browser isFreeze. ] ifNil: [ true ]
]

{ #category : #accessing }
AlceAbstractWidget >> miSelectedItem [
	^ selection
]

{ #category : #testing }
AlceAbstractWidget >> propagate [

	browser ifNotNil: [ browser propagate ]
]

{ #category : #accessing }
AlceAbstractWidget >> selectEntity: anEntity [

	(self accept: anEntity) ifFalse: [ ^ self ].
	toSelect := anEntity.
	AbstractBrowserMode actionFor: self
]

{ #category : #accessing }
AlceAbstractWidget >> selection: aSelection [ 
	selection := aSelection selectedItem.

	self propagate. 
]

{ #category : #testing }
AlceAbstractWidget >> title [
 	^ self class title. 
]
