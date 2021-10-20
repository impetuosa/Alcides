Class {
	#name : #AlceParetoChart,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'metrics'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'as yet unclassified' }
AlceParetoChart class >> runDragMe [

	^ self runMe
]

{ #category : #accessing }
AlceParetoChart >> accept: anEntity [

	^ anEntity isKindOf: AlcixModel 
]

{ #category : #initialization }
AlceParetoChart >> associationCounts [

	^ self subclassResponsibility
]

{ #category : #initialization }
AlceParetoChart >> chartTitle [

	^ 'Paradigmatic complexity'
]

{ #category : #visiting }
AlceParetoChart >> followAction [

	toSelect ifNil: [ toSelect := MooseModelRoot root entities anyOne ].

	metrics := MTRAlceMetricsExtractor metricsFor: toSelect.
	super followAction
]

{ #category : #initialization }
AlceParetoChart >> initCanvas: canvas [

	canvas @ (RSCanvasController new
		 noLegend;
		 in: [ :i | 
			 canvas newAnimation
				 duration: 500 milliSeconds;
				 onStepDo: [ canvas signalUpdate ];
				 when: RSAnimationEndEvent
				 do: [ i configuration noZoomToFitOnExtendChanged ].
			 i configuration
				 maxScale: 3;
				 minScale: 0.1
			 "useBasicZoom;" ];
		 yourself)
]

{ #category : #initialization }
AlceParetoChart >> loadChart: aCanvas withElement: anElement [

	| all values accumulated hundred accumulatedPct c |
	self mustRefresh  ifFalse: [ ^ self  ].
	self initCanvas: aCanvas.
	all := self associationCounts sort: [ :a :b | a value > b value ].

	values := all collect: #value.

	accumulated := Array new: values size.
	1 to: values size do: [ :i | 
		accumulated at: i put: (values at: i).
		i > 1 ifTrue: [ 
			| acc |
			acc := (accumulated at: i) + (accumulated at: i - 1).
			accumulated at: i put: acc ] ].
	accumulated := accumulated collect: [: a |  a  - ( accumulated first ) ].
	hundred := values sum.
	hundred := 1 max: hundred.
	"accumulatedPct := (accumulated collect: [ :a | 
		                   a
		                   ->
		                   ((a / hundred * 100 asFloat 
			                     printShowingDecimalPlaces: 2) , #%) ])
		                  asDictionary."
	c := RSChart new.

	c barHeights: values.
	c addPlot: (RSLinePlot new
			 x: (1 to: values size) y: accumulated;
			 color: Color red).
	c addDecoration:
		(RSHorizontalTick new fromNames: (all collect: #key)).
	c addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 asFloat).

	c container: aCanvas.
	c xlabel: self xLabel.
	c ylabel: self yLabel.
	c title: self chartTitle.
	c build
]

{ #category : #initialization }
AlceParetoChart >> xLabel [

	^ ' Projects '
]

{ #category : #initialization }
AlceParetoChart >> yLabel [

	^ ' #IncompatibleEntities '
]
