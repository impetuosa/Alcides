Class {
	#name : #AlcePieChartWidget,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'reference',
		'colorSelector'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlcePieChartWidget class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup register:
		(MiPropagateCommand forSpecContext: presenterInstance).
	rootCommandGroup register:
		(MiSystemInspectCommand forSpecContext: presenterInstance).

	MiTagEntity
		buildCommandsGroupWith: presenterInstance
		forRoot: rootCommandGroup
]

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
AlcePieChartWidget class >> runDragMe [

	^ self runMe
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> calculateObjectsFor: element [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> coloringPieStrategy [

	^ [ :a | a model key color ]
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> followAction [ 
	super followAction. 
	toSelect ifNil: [ toSelect := MooseModelRoot root entities anyOne ].
	reference script: [ : canvas | self loadReference: canvas withElement: toSelect ]
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> initCanvas: canvas [

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

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> initializePresenters [ 
	 super initializePresenters. 
	reference := self instantiate: SpRoassalPresenter .

]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> loadChart: aCanvas withElement: element [

	| chart pieTitle pairs |
	self mustRefresh ifFalse: [ ^ self ].
	element ifNil: [ ^ self ].
	self initCanvas: aCanvas.
	chart := RSPie new.

	chart container: aCanvas.
	chart sliceShape
		innerRadius: 70;
		externalRadius: 150;
		segmentSpacing: 0.1.
	chart sliceColor: self coloringPieStrategy.

	pairs := (self calculateObjectsFor: element) associations.

	(pairs collect: #value) sum > 0 ifFalse: [ ^ self ].

	chart
		objects: pairs;
		slice: [ :s | s value ];
		build.


	pieTitle := RSPieTitleInteraction new.
	pieTitle labelShape
		fontSize: 10;
		color: Color black.
	pieTitle labelText: 'Usage # ' , chart totalSum asString.
	chart build.

	chart shapes @ (RSPopup text: [ :obj | 
		 obj key name , ' (' , ((obj value * 100 / chart totalSum) asFloat 
			  printShowingDecimalPlaces: 2) asString , '%)' ]).





	chart canvas @ pieTitle.

	^ chart
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> loadReference: canvas withElement: element [

	| generator result ticks scale bscale canvasRect box objects |
	element ifNil: [ ^ self ].
	objects := self calculateObjectsFor: element.
	generator := RSLabelGenerator new.
	generator setLooseFlag: true.
	result := generator
		          searchMin: 0
		          max: (self referenceMaximumFor: element)
		          desired: 5.
	ticks := result min to: result max by: result step.
	canvasRect := Rectangle
		              floatCenter: 0 @ 0
		              extent: canvas extent * 0.9.
	scale := NSScale linear
		         domain: { 
				         result min.
				         result max };
		         range: { 
				         canvasRect bottom.
				         canvasRect top }.
	bscale := NSScale linear
		          domain: { 
				          0.
				          element mooseModel size };
		          range: { 
				          0.
				          canvasRect height }.

	box := RSBox new
		       color: Color lightGray;
		       extent:
			       20 @ (bscale scale: (self scaleForSelectedElement: objects));
		       yourself.
	box position: -10 @ ((scale scale: 0) - (box height / 2)).
	canvas add: box.
	canvas addAll: (ticks collect: [ :t | 
			 RSLabel new
				 position: 20 @ (scale scale: t);
				 text: (t >= 1000
						  ifTrue: [ (t / 1000 printShowingDecimalPlaces: 1) , 'K' ]
						  ifFalse: [ t asInteger asString ]);
				 yourself ]).

	canvas add: (RSPolyline new
			 controlPoints: (ticks collect: [ :p | -10 @ (scale scale: p) ]);
			 marker: (RSBox new
					  extent: 10 @ 2;
					  color: Color black);
			 yourself)
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> mustRefresh [

	^ mustRefresh ifNil: [ false ]
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> referenceMaximumFor: element [ 
	 self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> refresh [
	mustRefresh := true. 
	self followAction
]

{ #category : #'as yet unclassified' }
AlcePieChartWidget >> scaleForSelectedElement: element [ 
	 self subclassResponsibility 
]

{ #category : #accessing }
AlcePieChartWidget >> script: aFullBlockClosure [

	viewport script: aFullBlockClosure
]
