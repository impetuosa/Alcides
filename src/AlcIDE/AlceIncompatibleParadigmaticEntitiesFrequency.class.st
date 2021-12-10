Class {
	#name : #AlceIncompatibleParadigmaticEntitiesFrequency,
	#superclass : #AlceParetoChart,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlceIncompatibleParadigmaticEntitiesFrequency class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcParadgimChartBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'world menu' }
AlceIncompatibleParadigmaticEntitiesFrequency class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'world menu' }
AlceIncompatibleParadigmaticEntitiesFrequency class >> title [

	^ ' Paradigmatic Complexity '
]

{ #category : #initialization }
AlceIncompatibleParadigmaticEntitiesFrequency >> associationCounts [

	^ metrics paradigmaticCounts
]

{ #category : #initialization }
AlceIncompatibleParadigmaticEntitiesFrequency >> chartTitle [

	^ 'Paradigmatic Complexity'
]
