Class {
	#name : #AlceAbstractWidget,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'selection',
		'toSelect',
		'browser',
		'dragMe',
		'dragMeOut',
		'close'
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
		  add: (SpBoxLayout newLeftToRight
				   add: #dragMe;
				   add: #dragMeOut width: self iconWidth;
				   add: #close width: self iconWidth;
				   yourself)
		  height: self toolbarHeight;
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
AlceAbstractWidget >> adaptToDropInto: aDropDestination [

	owner hasLeft: self.
	^ self
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

{ #category : #testing }
AlceAbstractWidget >> canBeAdaptedToDropInto: aDestination [
	^ true
]

{ #category : #accessing }
AlceAbstractWidget >> colorForTable: anEntity [

	^ anEntity color
]

{ #category : #testing }
AlceAbstractWidget >> dragTilte [

	dragMe label: self title
]

{ #category : #opening }
AlceAbstractWidget >> followAction [

	self subclassResponsibility
]

{ #category : #actions }
AlceAbstractWidget >> freezeAction [

	^ self
]

{ #category : #opening }
AlceAbstractWidget >> hasBeenReinstalled [
	self dragTilte.
	selection := toSelect.
	selection ifNotNil: [ self followAction ].
]

{ #category : #testing }
AlceAbstractWidget >> iconFor: anEntity [

	(anEntity respondsTo: #type) ifNil: [ 
		^ MiAlceIdeIcons untypedfieldIcon ].
	^ MiAlceIdeIcons iconFor: anEntity
]

{ #category : #actions }
AlceAbstractWidget >> initializePresenters [

	super initializePresenters.
	dragMe := self instantiate: SpDragMe.
	dragMe passenger: self.
	dragMe label: 'Drag'.
	dragMeOut := self newButton.
	dragMeOut action: [ 
		owner hasLeft: self. 
		AlceBrowser new
			widget: self;
			openWithSpec.
 ].
	dragMeOut label:'->'.
	close := self newButton.
	close label: 'X'
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

{ #category : #testing }
AlceAbstractWidget >> isMiBrowser [

	^ false
]

{ #category : #accessing }
AlceAbstractWidget >> miSelectedItem [
	^ selection
]

{ #category : #testing }
AlceAbstractWidget >> propagate [

	browser ifNotNil: [ browser propagate: self  ]
]

{ #category : #accessing }
AlceAbstractWidget >> selectEntity: anEntity [

	(self accept: anEntity) ifFalse: [ ^ self ].
	toSelect := anEntity.
	AbstractBrowserMode actionFor: self
]

{ #category : #accessing }
AlceAbstractWidget >> selection: aSelection [

	| items |
	(aSelection respondsTo: #selectedItems)
		ifTrue: [ 
			items := aSelection selectedItems.
			selection := items size = 1
				             ifTrue: [ items first ]
				             ifFalse: [ items ] ]
		ifFalse: [ selection := aSelection ].

	self propagate
]

{ #category : #testing }
AlceAbstractWidget >> title [
 	^ self class title. 
]

{ #category : #actions }
AlceAbstractWidget >> whenClose: aBlock [

	close action: [ aBlock cull: self cull: self owner ]
]
