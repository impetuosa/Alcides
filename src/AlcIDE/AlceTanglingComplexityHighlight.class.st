Class {
	#name : #AlceTanglingComplexityHighlight,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'canvas',
		'mooseModel'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #accessing }
AlceTanglingComplexityHighlight class >> title [

	^ 'Tangling Complexity Highlight'
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> canFollowEntity: anObject [

	| ans |
	(anObject isKindOf: AlcixAccessModule) ifTrue: [ 
		ans := (UIManager default question:
			        'Calculating the architectural dependencies will take some minutes (maybe up to 20''). Do you want to proceed?') 
			       ifNil: [ false ].

		^ ans ].

	^ (anObject isKindOf: AlcixModule) or: [ 
		  (anObject isKindOf: Association) and: [ 
			  anObject value isCollection and: [ 
				  anObject value allSatisfy: [ :v | v isKindOf: AlcixModule ] ] ] ]
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> initCanvas: canvas [

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
AlceTanglingComplexityHighlight >> loadChart: aCanvas withElement: element [

	canvas := aCanvas.

	element accept: self.
	self initCanvas: canvas. 
	^ canvas. 
]

{ #category : #'as yet unclassified' }
AlceTanglingComplexityHighlight >> mooseModel [

	^ mooseModel
]

{ #category : #'as yet unclassified' }
AlceTanglingComplexityHighlight >> newBorder [

	^ RSBorder new
		  color: Color black;
		  width: 5;
		  yourself
]

{ #category : #'as yet unclassified' }
AlceTanglingComplexityHighlight >> plotFor: aCollection [

	| popup label padding high packages |
	popup := RSPopup new.
	label := RSLabeled new highlightable.
	padding := 1 asMargin.
	high := RSHighlightable new.
	mooseModel ifNil: [ ^ self ].
	packages := aCollection
		            collect: [ :p | 
			            | classes pkg |
			            classes := p value
				                       collect: [ :cls | 
					                       | methods |
					                       methods := cls invocables collect: [ :met | 
						                                  | mtric tang |
						                                  mtric := self mooseModel
							                                           metrics metricsFor:
							                                           met.

						                                  (mtric isKindOf: MTRAstMetric)
							                                  ifTrue: [ 
								                                  tang := mtric
									                                          tanglingLanguageReferencesRatios.

								                                  RSBox new
									                                  extent:
										                                  (((tang first *10) ln   asInteger max: 1)
										                                  @ ((tang second *10) ln   asInteger max: 1)) *10 ;
									                                  @ popup;
									                                  @ high;
									                                  color:
										                                  (Color black alpha:
												                                   (mtric astSize ln / 10 
													                                    max: 0.01));
									                                  model: met;
									                                  yourself ]
							                                  ifFalse: [ 
								                                  RSBox new
									                                  extent: 50 @ 50;
									                                  @ popup;
									                                  @ high;
									                                  color: Color red;
									                                  model: met;
									                                  yourself ] ].
					                       RSGridLayout on:
						                       (methods sort:
							                        [ :a | a extent x * a extent y ]
								                        descending).
					                       RSComposite new
						                       model: cls;
						                       @ popup;
						                       draggable;
						                       paint: Color transparent;
						                       border: self newBorder;
						                       children: methods;
						                       padding: padding;
						                       yourself ]
				                       as: RSGroup.
			            RSGridLayout on: (classes sort: [ :a | 
					             (a children collect: [ :m | 
						              m extent x * m extent y * m color alpha ]) sum ]
						             descending).

			            pkg := RSComposite new
				                   children: classes;
				                   paint: Color transparent ;
				                   model: p key;
				                   @ popup;
				                   border: self newBorder;
				                   draggable;
				                   yourself.

			            pkg ]
		            as: RSGroup.
	RSFlowLayout on: packages.



	canvas addAll: packages
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitAccessModule: anAlcixAccessModule [

	mooseModel := anAlcixAccessModule mooseModel.
	self plotFor:
		(anAlcixAccessModule types groupedBy: #class) associations
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitAssociation: anAssociation [

	mooseModel := anAssociation value anyOne mooseModel.
	self plotFor: { anAssociation }
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitClass: anAlcixClass [ 
	self visitModule: anAlcixClass 
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitForm: anAlcixForm [

	self visitModule: anAlcixForm
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitModule: anAlcixModule [

	self visitAssociation: #Module -> { anAlcixModule }
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitQuery: anAlcixQuery [ 
	self visitTable: anAlcixQuery 
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitReport: anAlcixReport [

	self visitModule: anAlcixReport
]

{ #category : #visiting }
AlceTanglingComplexityHighlight >> visitTable: anAlcixTable [ 
	self visitModule: anAlcixTable 
]
