Class {
	#name : #AlceGraphClusteringToRoassalGraphHLWidget,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'cluster',
		'graphToRoassal',
		'clusteringAlgorithm'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphHLWidget >> canFollowEntity: aModel [

	^ { 
		  AlcixModule.
		  AlcixAccessModule } anySatisfy: [ :a | aModel isKindOf: a ]
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphHLWidget >> clusteringAlgorithm: anAlgo [
 	clusteringAlgorithm := anAlgo
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphHLWidget >> clusteringBehavior [

	self clusteringAlgorithm: [ AlceClusteringNearHorizontal new ]
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphHLWidget >> clusteringState [

	self clusteringAlgorithm: [ AlceClusteringVariables new ]
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphHLWidget >> loadChart: aCanvas withElement: anElement [

	| classes root builder |
	cluster := clusteringAlgorithm value. 
	
	cluster mooseModel: anElement mooseModel.
	anElement accept: cluster.

	graphToRoassal := AlceGraphToRoassalGraphHL new
		                  cluster: cluster;
		                  element: anElement;
		                  yourself.
	cluster graph nodes do: [ :node | graphToRoassal processNode: node ].

	root := HNode new
		        name: #root;
		        rawModel: anElement;
		        yourself.

	classes := self
		           processClassesFrom: graphToRoassal
		           withCluster: cluster.

	root children: classes.
	'Startingt to build visu' traceCr.
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

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphHLWidget >> menuInteraction [

	^ RSMenuActivable new
		  menuDo: [ :menu :aShape | 
			  AlceGraphAbstractMenuItem
				  buildIn: menu
				  shape: aShape
				  visualization: self ];
		  yourself
]

{ #category : #'as yet unclassified' }
AlceGraphClusteringToRoassalGraphHLWidget >> processClassesFrom: anAlceGraphToRoassalGraph withCluster: anAlceClusteringVariables [

	| clazzes clazz |
	clazzes := OrderedCollection new.

	anAlceGraphToRoassalGraph architectureComposites keysAndValuesDo: [ 
		:class 
		:archs | 
		(class isKindOf: AlcixModule) ifTrue: [ 
			clazz := HNode new.
			clazzes add: clazz.
			clazz name: class container name , '.' , class name.
			clazz addAll: archs.
			clazz ].

		(class isKindOf: FamixTag) ifTrue: [ 
			clazz := HNode new.
			clazzes add: clazz.
			clazz name: class name.
			clazz addAll: archs.
			clazz color: class color.
			clazz ] ].
	^ clazzes
]
