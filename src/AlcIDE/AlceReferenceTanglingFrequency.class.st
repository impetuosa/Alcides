Class {
	#name : #AlceReferenceTanglingFrequency,
	#superclass : #AlceParetoChart,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlceReferenceTanglingFrequency class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcReferenceFreqChartBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'world menu' }
AlceReferenceTanglingFrequency class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'world menu' }
AlceReferenceTanglingFrequency class >> title [

	^ 'Simple Dependencies Refence Frequency'
]

{ #category : #initialization }
AlceReferenceTanglingFrequency >> associationCounts [

	^ metrics referencesTangling 
]

{ #category : #initialization }
AlceReferenceTanglingFrequency >> chartTitle [ 
	^ 'Simple Dependencies Refence Frequency'
]
