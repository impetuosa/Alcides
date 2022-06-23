Class {
	#name : #AlceDraggableWidget,
	#superclass : #MiDraggableAbstractWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #commands }
AlceDraggableWidget class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup register:
		(MiPropagateCommand forSpecContext: presenterInstance).
	rootCommandGroup register:
		(MiSystemInspectCommand forSpecContext: presenterInstance).

	MiTagEntity
		buildCommandsGroupWith: presenterInstance
		forRoot: rootCommandGroup
]

{ #category : #'as yet unclassified' }
AlceDraggableWidget class >> runDragMe [

	^ self runMe
]

{ #category : #actions }
AlceDraggableWidget >> followEntity: anAlcixModel [

	toSelect := anAlcixModel.
	self followAction
]

{ #category : #defaults }
AlceDraggableWidget >> iconFor: anEntity [

	(anEntity respondsTo: #type) ifNil: [ 
		^ MiAlceIdeIcons untypedfieldIcon ].
	^ MiAlceIdeIcons iconFor: anEntity
]

{ #category : #defaults }
AlceDraggableWidget >> initCanvas: canvas [

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
