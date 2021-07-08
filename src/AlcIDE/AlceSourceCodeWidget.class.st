Class {
	#name : #AlceSourceCodeWidget,
	#superclass : #AlceAbstractWidget,
	#instVars : [
		'viewport'
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

	^ (aModel isKindOf: AlcixModule) or: [ aModel isKindOf: AlceAnchor ]
]

{ #category : #initialization }
AlceSourceCodeWidget >> followAction [

	(toSelect isKindOf: AlcixModule) ifTrue: [ 
		toSelect isAstLoaded ifTrue: [ 
			viewport text: (AlceTextComposer new
					 compose: toSelect ast
					 model: toSelect
					 style: self vbaStyle
					 browsingWith: self) ] ].

	(toSelect isKindOf: AlceAnchor) ifTrue: [ 
		toSelect containsSource ifTrue: [ 
			viewport selectFrom: toSelect srcFrom to: toSelect srcTo ] ]
]

{ #category : #initialization }
AlceSourceCodeWidget >> initializePresenters [

	super initializePresenters.
	viewport := self newText
]

{ #category : #initialization }
AlceSourceCodeWidget >> vbaStyle [

	^ AlceVBAStyle new
		  usePopularColorStrategy;
		  yourself
]
