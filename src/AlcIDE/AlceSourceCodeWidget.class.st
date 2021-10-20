Class {
	#name : #AlceSourceCodeWidget,
	#superclass : #AlceDraggableWidget,
	#instVars : [
		'viewport',
		'pagesObjectsMap'
	],
	#category : #'AlcIDE-MidasWidgets'
}

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
		parent:  AlcIDE alceBrowsers; 
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceSourceCodeWidget class >> runMe [
	<script>
	^ super runMe
]

{ #category : #specs }
AlceSourceCodeWidget class >> title [

	^ 'Alce Source Browser'
]

{ #category : #visiting }
AlceSourceCodeWidget >> accept: aModel [

	(aModel isKindOf: JinAnchor) ifTrue: [ ^ true ].

	^ (aModel isKindOf: AlcixModule) and: [ 
		  (aModel container isKindOf: AlcixLibrary) not ]
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
	pagesObjectsMap := Dictionary new.
	viewport := self newNotebook.
	viewport whenPageRemovedDo: [ :p | 
		pagesObjectsMap removeKey: p ifAbsent: [  ] ].
	viewport whenPagesChangedDo: [ :p | 
		pagesObjectsMap at: p ifPresent: [ :m | self selectEntity: m ] ]
]

{ #category : #initialization }
AlceSourceCodeWidget >> newNotebookPageFor: aModule [

	| p |
	p := self newNotebookPage.
	pagesObjectsMap at: p put: aModule.
	^ p
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
AlceSourceCodeWidget >> vbaStyleWith: aColoringStrategy [

	^ AlceVBAStyle new
		  useColorStrategy: aColoringStrategy;
		  yourself
]

{ #category : #initialization }
AlceSourceCodeWidget >> visualizeSourcecode: aModule [

	| text page coloringStrategy |
	(aModule isKindOf: AlcixDataSource) ifTrue: [ ^ self ].
	viewport pages
		detect: [ :p | p title = aModule name ]
		ifFound: [ :p | 
			viewport selectPage: p.
			^ p ].
	toSelect stringContent ifNil: [ ^ self ].
	text := self newText.
	text help: aModule container name , '.' , aModule name.
	page := (self newNotebookPageFor: aModule)
		        title: aModule name;
		        presenterProvider: text;
		        icon: (self iconFor: aModule);
		        beCloseable.


	viewport addPage: page.
	viewport selectPage: page.
	coloringStrategy := (aModule mooseModel coloringStrategyFor:
		                     AlceHorizontalColorPropagation) mostPopular.
	text text: (AlceTextComposer new
			 compose: toSelect stringContent
			 ast: (toSelect isAstLoaded
					  ifTrue: [ toSelect ast ]
					  ifFalse: [ nil ])
			 model: toSelect
			 style: (self vbaStyleWith: coloringStrategy)
			 browsingWith: self)
]
