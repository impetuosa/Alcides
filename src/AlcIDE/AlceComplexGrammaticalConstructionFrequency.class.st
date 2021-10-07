Class {
	#name : #AlceComplexGrammaticalConstructionFrequency,
	#superclass : #AlceParetoChart,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlceComplexGrammaticalConstructionFrequency class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcGrammarChartBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'world menu' }
AlceComplexGrammaticalConstructionFrequency class >> runMe [
	<script>
	super runMe
]

{ #category : #'world menu' }
AlceComplexGrammaticalConstructionFrequency class >> title [

	^ 'Grammar complexity'
]

{ #category : #initialization }
AlceComplexGrammaticalConstructionFrequency >> associationCounts [

	^ metrics grammaticalCounts
]

{ #category : #initialization }
AlceComplexGrammaticalConstructionFrequency >> chartTitle [
	^ 'Complex Grammatical Construction Frequency'
]

{ #category : #initialization }
AlceComplexGrammaticalConstructionFrequency >> title [
	^ 'Grammar Complexity'
]
