Class {
	#name : #AlceMetricsChart,
	#superclass : #AlceHistogramChart,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #accessing }
AlceMetricsChart class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcGrammarChartBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #accessing }
AlceMetricsChart class >> title [
	^ 'Demographics'
]

{ #category : #initialization }
AlceMetricsChart >> associationCounts [

	^ metrics counters
]

{ #category : #initialization }
AlceMetricsChart >> chartTitle [

	^ 'Demographic Metrics'
]

{ #category : #initialization }
AlceMetricsChart >> xLabel [

	^ 'Counter'
]

{ #category : #initialization }
AlceMetricsChart >> yLabel [

	^ 'Amount'
]
