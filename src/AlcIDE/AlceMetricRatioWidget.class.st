Class {
	#name : #AlceMetricRatioWidget,
	#superclass : #AlcePieChartWidget,
	#instVars : [
		'metrics'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #visiting }
AlceMetricRatioWidget >> accept: anEntity [

	^ anEntity isKindOf: AlcixModel 
]

{ #category : #visiting }
AlceMetricRatioWidget >> coloringPieStrategy [

	^ NSScale google20
]

{ #category : #visiting }
AlceMetricRatioWidget >> followAction [

	toSelect ifNil: [ toSelect := MooseModelRoot root entities anyOne ].

	metrics := MTRAlceMetricsExtractor metricsFor: toSelect.
	super followAction
]

{ #category : #'as yet unclassified' }
AlceMetricRatioWidget >> referenceMaximumFor: element [ 
	^ ((self calculateObjectsFor: element)  collect: [ :c | c value ])
		  sum
]

{ #category : #visiting }
AlceMetricRatioWidget >> scaleForSelectedElement: objects [

	^ objects size
]
