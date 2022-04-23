Class {
	#name : #AlceModuleLocChart,
	#superclass : #AlceMetricsChart,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #accessing }
AlceModuleLocChart class >> menuCommandOn: aBuilder [

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
AlceModuleLocChart class >> title [
	^ 'Module General Measures'
]

{ #category : #initialization }
AlceModuleLocChart >> associationCounts [

	^ metrics moduleGeneralCounters
]

{ #category : #initialization }
AlceModuleLocChart >> canFollowEntity: anEntity [

	^ anEntity isKindOf: AlcixAccessModule 
]
