Class {
	#name : #AlceTagUsageRatioChartWidget,
	#superclass : #AlcePieChartWidget,
	#instVars : [
		'mooseModel'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlceTagUsageRatioChartWidget class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcTagChartBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #specs }
AlceTagUsageRatioChartWidget class >> runMe [
	<script>
	^ super runMe
]

{ #category : #accessing }
AlceTagUsageRatioChartWidget class >> title [

	^ 'Alce Tangling Ratio Browser'
]

{ #category : #visiting }
AlceTagUsageRatioChartWidget >> accept: anEntity [

	(anEntity isKindOf: AlcixModel) ifTrue: [ 
		self mooseModel: anEntity.
		^ false ].

	(anEntity isKindOf: AlcixEntity) ifTrue: [ 
		mooseModel ifNil: [ self mooseModel: anEntity mooseModel ].
		^ true ].
	^ false
]

{ #category : #'as yet unclassified' }
AlceTagUsageRatioChartWidget >> calculateObjectsFor: element [

	| baseline |
	element ifNil: [ ^ {  } ].
	baseline := self colorsFor: element.

	^ ((baseline groupedBy: #tag) associations collect: [ :assoc | 
		   assoc key -> assoc value size ]) asDictionary
]

{ #category : #'as yet unclassified' }
AlceTagUsageRatioChartWidget >> coloringStrategyFor: aClass [

	^ mooseModel coloringStrategyFor: aClass
]

{ #category : #'as yet unclassified' }
AlceTagUsageRatioChartWidget >> colorsFor: anAlcixClass [

	^ mooseModel selectedColoringStrategy colorsFor: anAlcixClass
]

{ #category : #visiting }
AlceTagUsageRatioChartWidget >> mooseModel: aModel [

	mooseModel := aModel
]

{ #category : #'as yet unclassified' }
AlceTagUsageRatioChartWidget >> referenceMaximumFor: element [

	^ element mooseModel size
]

{ #category : #'as yet unclassified' }
AlceTagUsageRatioChartWidget >> scaleForSelectedElement: objects [

	^ ((objects collect: [ :o | o value ]) ifEmpty: [ { 0 } ]) sum
]
