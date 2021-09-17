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
