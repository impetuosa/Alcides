Class {
	#name : #AlceTagDistribution,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'colorSelector',
		'mooseModel'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #accessing }
AlceTagDistribution class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcTagDistributionBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'as yet unclassified' }
AlceTagDistribution class >> runDragMe [
	self runMe
]

{ #category : #accessing }
AlceTagDistribution class >> title [
	^ 'Architectural Distribution'
]

{ #category : #visiting }
AlceTagDistribution >> canFollowEntity: anEntity [

	| ans |
	(anEntity isKindOf: AlcixModel) ifTrue: [ 
		self mooseModel: anEntity.

		ans := (UIManager default question:
			        'Calculating the tangling complexity for a full project may take some minutes. Do you want to proceed?') 
			       ifNil: [ false ].

		^ ans ].

	(anEntity isKindOf: AlcixEntity) ifTrue: [ 
		mooseModel ifNil: [ self mooseModel: anEntity mooseModel ] ].
	^ false
]

{ #category : #visiting }
AlceTagDistribution >> colorsFor: anAlcixClass [

	^ mooseModel selectedColoringStrategy colorsFor: anAlcixClass
]

{ #category : #visiting }
AlceTagDistribution >> currentCategory [

	^ mooseModel selectedColoringStrategy selectingCategory
]

{ #category : #visiting }
AlceTagDistribution >> initCanvas: canvas [

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

{ #category : #visiting }
AlceTagDistribution >> loadChart: aCanvas withElement: element [

	| allModels |
	self mustRefresh  ifFalse: [ ^ self  ].
	element ifNil: [ ^ self ].
	mooseModel ifNil: [ ^ self ].

	self initCanvas: aCanvas.
	allModels := mooseModel references flatCollect: [ :m | 
		             ((self colorsFor: m) collect: #tag) asSet
			             asOrderedCollection collect: [ :t | t -> m ] ].


	HDistributionMap new
		elements: self currentCategory markedTags;
		childrenBlock: [ :tag | 
			allModels select: [ :c | c key = tag ] thenCollect: #value ];
		propertyBlock: [ :val | 
			(allModels select: [ :m | m value = val ]) size ];
		colorMap: RSColorPalette diverging rdgy4;
		container: aCanvas;
		build
]

{ #category : #visiting }
AlceTagDistribution >> mooseModel: aModel [

	mooseModel := aModel
]
