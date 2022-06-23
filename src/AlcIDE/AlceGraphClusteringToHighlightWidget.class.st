Class {
	#name : #AlceGraphClusteringToHighlightWidget,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'cluster',
		'graphToRoassal'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #initialization }
AlceGraphClusteringToHighlightWidget >> canFollowEntity: aModel [
	^( aModel isKindOf: AlcixModule ) 
]

{ #category : #initialization }
AlceGraphClusteringToHighlightWidget >> loadChart: aCanvas withElement: anElement [

	| mapped project root builder |
	cluster := AlceClusteringFunction new.
	
	cluster mooseModel: anElement mooseModel.
	root := HNode new name: #Root.
	graphToRoassal := AlceGraphToRoassalHighlightNode new
		                  cluster: cluster;
		                  element: anElement;
		                  yourself.

	anElement accept: cluster.

	project := anElement mooseModel project.


	cluster graph nodes do: [ :node | graphToRoassal processNode: node ].


	mapped := graphToRoassal mapped.

	root children: (mapped values select: [ :a | 
			 a parent isNil and: [ (a rawModel = project) not ] ]).

	builder := HSimpleVisualizationBuilder new
		           rootNode: root;
		           container: aCanvas.
	builder lineBuilder width: 2.

	builder build.
	root collapseChildren.
	root children do: [ :child | 
		child collapseChildren.
		child position: nil.
		child children do: [ :ch2 | 
			ch2 collapseChildren.
			ch2 position: nil ] ].
	builder layoutOn: builder container nodes parent: root.
	builder container signalUpdate.

	aCanvas @ RSCanvasController.
	^ aCanvas
]
