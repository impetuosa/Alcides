Class {
	#name : #AlcePieChartWidget,
	#superclass : #AlceRoassalWidget,
	#instVars : [
		'reference',
		'colorSelector',
		'buffer'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlcePieChartWidget class >> defaultSpec [

	^ self basicDefaultSpec
		  add: (SpBoxLayout newLeftToRight
				   add: #reference withConstraints: [:c | c width: 150];
				   add: #viewport);
		  add: #refresh height: self toolbarHeight;
		  yourself
]

{ #category : #'world menu' }
AlcePieChartWidget class >> isAbstract [

	^ self = AlcePieChartWidget
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> calculateObjectsFor: element [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> colorFor: e [

	^ colorSelector colorFor: e
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> colorsFor: e [

	^ colorSelector colorsFor: e
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> followAction [ 
	 super followAction. 
	reference script: [ : canvas | self loadReference: canvas withElement: toSelect ]
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> initialize [

	super initialize.
	colorSelector := AlceColoringPopularComposingColor new.
	buffer := Dictionary new
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> initializePresenters [ 
	 super initializePresenters. 
	reference := self instantiate: SpRoassalPresenter .
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> loadChart: aCanvas withElement: element [

	| chart |
	chart := RSPie new.

	chart container: aCanvas.
	chart sliceShape
		innerRadius: 70;
		externalRadius: 150;
		segmentSpacing: 0.1.
	chart sliceColor: [ :a | a model key ].
	chart
		objects: (self calculateObjectsFor: element);
		slice: [ :s | s value size ];
		build.
	^ chart
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> loadReference: canvas withElement: element [ 

	| generator result ticks scale bscale canvasRect box objects |
	
	objects := self calculateObjectsFor: element. 
	objects inspect. 
	generator := RSLabelGenerator new.
	generator setLooseFlag: true.
	result := generator searchMin: 0 max: (self referenceMaximumFor: element ) desired: 5.
	ticks := result min to: result max by: result step.
	canvasRect := Rectangle
		floatCenter: 0@0
		extent: canvas extent * 0.9.
	scale := NSScale linear
		domain: {result min. result max};
		range: {canvasRect bottom. canvasRect top }.
	bscale := NSScale linear
		domain: { 0. element mooseModel size  };
		range: { 0. canvasRect height }.
	
	box := RSBox new
		color: Color lightGray;
		extent: 20@ (bscale scale: (self scaleForSelectedElement: objects ) );
		yourself.
	box position: -10 @ ((scale scale: 0) - (box height /2 )).
	canvas add: box.
	canvas addAll: (ticks collect:[:t | 
		RSLabel new
			position: 20@ (scale scale: t);
			text: (t >= 1000
				ifTrue: [ ((t / 1000) printShowingDecimalPlaces: 1) ,'K' ]
				ifFalse: [ t asInteger asString ]);
			yourself ]).
	
	canvas add: (RSPolyline new
		controlPoints: (ticks collect: [:p | -10 @ (scale scale: p)]);
		marker: (RSBox new extent: 10@2; color: Color black);
		yourself)
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> referenceMaximumFor: element [ 
	 self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> refresh [

	buffer removeKey: toSelect.
	super refresh
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> scaleForSelectedElement: element [ 
	 self subclassResponsibility 
]

{ #category : #accessing }
AlcePieChartWidget >> script: aFullBlockClosure [

	viewport script: aFullBlockClosure
]
