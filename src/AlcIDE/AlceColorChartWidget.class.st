Class {
	#name : #AlceColorChartWidget,
	#superclass : #AlcePieChartWidget,
	#instVars : [
		'strategies'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceColorChartWidget class >> defaultSpec [

	^ self basicDefaultSpec
		  add: #strategies height: 50;
		  add: (SpBoxLayout newLeftToRight
				   add: #reference withConstraints: [ :c | c width: 150 ];
				   add: #viewport);
		  add: #refresh height: self toolbarHeight;
		  yourself
]

{ #category : #'world menu' }
AlceColorChartWidget class >> menuCommandOn: aBuilder [

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
AlceColorChartWidget class >> runMe [
	<script>
	super runMe
]

{ #category : #accessing }
AlceColorChartWidget class >> title [

	^ 'Alce Tag Browser'
]

{ #category : #visiting }
AlceColorChartWidget >> accept: anEntity [
	^ { 
		  AlcixModel.
		  AlcixContainer } anySatisfy: [ :a | anEntity isKindOf: a ]
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> calculateObjectsFor: element [

	| baseline group |
	baseline := self colorsFor: element.


	^ baseline groupedBy: #yourself
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> colorsFor: anAlcixClass [

	^ strategies colorsFor: anAlcixClass
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> initializePresenters [

	super initializePresenters.
	strategies := self instantiate: AlceColorStrategySelectorWidget.
	strategies strategies: AlceColoringStrategy allSubclasses.
	strategies whenSelectionChangedDo: [ self refresh ]
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> referenceMaximumFor: element [

	^ element mooseModel size
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> scaleForSelectedElement: objects [

	^ ((objects collect: [ :o | o value size ]) ifEmpty: [ { 0 } ]) sum
]
