Class {
	#name : #AlceSourceCodeWidget,
	#superclass : #MiDraggableAbstractWidget,
	#instVars : [
		'viewport'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceSourceCodeWidget class >> alceBrowsers [

	^ 'Alce browsers'
]

{ #category : #specs }
AlceSourceCodeWidget class >> defaultSpec [
	^ super defaultSpec
		add: #viewport;
		yourself
]

{ #category : #specs }
AlceSourceCodeWidget class >> menuCommandOn: aBuilder [
	<worldMenu>
	
	<miBrowsers>
	(aBuilder item: #alceSourceBrowser)
		parent: self alceBrowsers; 
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceSourceCodeWidget class >> runMe [
	<script>
	super runMe
]

{ #category : #specs }
AlceSourceCodeWidget class >> title [

	^ 'Alce Source Browser'
]

{ #category : #visiting }
AlceSourceCodeWidget >> accept: aModel [

	^ (aModel isKindOf: AlcixModule) or: [ aModel isKindOf: JinAnchor ]
]

{ #category : #initialization }
AlceSourceCodeWidget >> followAction [

	(toSelect isKindOf: AlcixModule) ifTrue: [ 
		self visualizeSourcecode: toSelect ].

	(toSelect isKindOf: JinAnchor) ifTrue: [ 
		toSelect containsSource ifTrue: [ 
			self selectSourceCodeInterval: toSelect ] ]
]

{ #category : #initialization }
AlceSourceCodeWidget >> initializePresenters [

	super initializePresenters.
	viewport := self newNotebook .
	
]

{ #category : #initialization }
AlceSourceCodeWidget >> selectSourceCodeInterval: anAnchor [

	viewport pages
		detect: [ :p | p title = anAnchor elementName ]
		ifFound: [ :p | 
			viewport selectPage: p.
			p activePresenter selectFrom: toSelect srcFrom to: toSelect srcTo ]
]

{ #category : #initialization }
AlceSourceCodeWidget >> vbaStyle [

	^ AlceVBAStyle new
		  usePopularColorStrategy;
		  yourself
]

{ #category : #initialization }
AlceSourceCodeWidget >> visualizeSourcecode: aModule [

	| text page |
	(aModule isKindOf: AlcixDataSource ) ifTrue:[ ^ self ] .
	viewport pages
		detect: [ :p | p title = aModule name ]
		ifFound: [ :p | 
			viewport selectPage: p.
			^ p ].
	toSelect stringContent ifNil: [ ^ self ].
	text := self newText.
	text help: aModule container name , '.' , aModule name.
	page := self newNotebookPage
		        title: aModule name;
		        presenterProvider: text;
		        icon: (self iconFor: aModule);
		        beCloseable.

	viewport addPage: page.
	viewport selectPage: page.

	text text: (AlceTextComposer new
			 compose: toSelect stringContent
			 ast: (toSelect isAstLoaded
					  ifTrue: [ toSelect ast ]
					  ifFalse: [ nil ])
			 model: toSelect
			 style: self vbaStyle
			 browsingWith: self)
]
