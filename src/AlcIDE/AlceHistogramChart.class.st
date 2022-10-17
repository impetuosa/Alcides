Class {
	#name : #AlceHistogramChart,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'metrics'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'as yet unclassified' }
AlceHistogramChart class >> runDragMe [

	^ self runMe
]

{ #category : #initialization }
AlceHistogramChart >> associationCounts [

	^ self subclassResponsibility
]

{ #category : #accessing }
AlceHistogramChart >> canFollowEntity: anEntity [

	^ (anEntity isKindOf: AlcixModel) or: [ 
		  anEntity isKindOf: AlcixEntity ]
]

{ #category : #initialization }
AlceHistogramChart >> chartTitle [

	^ self subclassResponsibility 
]

{ #category : #visiting }
AlceHistogramChart >> followAction [

	| mooseModel |
	toSelect ifNil: [ toSelect := MooseModelRoot root entities anyOne ].
	mooseModel := (toSelect isKindOf: AlcixModel)
		              ifTrue: [ mooseModel := toSelect ]
		              ifFalse: [ 
		              mooseModel := MooseModelRoot root entities anyOne ].


	metrics := mooseModel metrics metricsFor: toSelect.

	super followAction
]

{ #category : #initialization }
AlceHistogramChart >> initCanvas: canvas [

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
AlceHistogramChart >> loadChart: aCanvas withElement: anElement [

	| all values c horizontal |
	self mustRefresh ifFalse: [ ^ self ].
	self initCanvas: aCanvas.
	all := self associationCounts sort: [ :a :b | a value > b value ].
	all ifEmpty: [ ^ self ].
	values := all collect: #value.



	c := RSChart new.
	horizontal := RSHorizontalTick new fromNames: (all collect: #key).
	all size > 4 ifTrue: [ horizontal useVerticalLabel ].
	c barHeights: values.

	c addDecoration: horizontal.

	c addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 asFloat).

	c container: aCanvas.
	c xlabel: self xLabel.
	c ylabel: self yLabel.
	c title: self chartTitle.
	horizontal configuration numberOfTicks = 0 ifTrue: [ 
		horizontal configuration numberOfTicks: 1 ].


	c build
]

{ #category : #initialization }
AlceHistogramChart >> xLabel [

	^ self subclassResponsibility
]

{ #category : #initialization }
AlceHistogramChart >> yLabel [

	^ self subclassResponsibility
]
