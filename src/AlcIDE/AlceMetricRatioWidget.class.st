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

	^( (anEntity isKindOf: AlcixModel) or: [ 
		  anEntity isKindOf: AlcixEntity ]) and: [ (anEntity isKindOf: AlcixDataSource ) not  ]
]

{ #category : #visiting }
AlceMetricRatioWidget >> coloringPieStrategy [

	^ NSLinearScale google20
]

{ #category : #visiting }
AlceMetricRatioWidget >> followAction [

	| mooseModel |
	toSelect ifNil: [ toSelect := MooseModelRoot root entities anyOne ].
	mooseModel := (toSelect isKindOf: AlcixModel)
		              ifTrue: [ mooseModel := toSelect ]
		              ifFalse: [ 
		              mooseModel := MooseModelRoot root entities anyOne ].


	metrics := mooseModel metrics metricsFor: toSelect.

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
