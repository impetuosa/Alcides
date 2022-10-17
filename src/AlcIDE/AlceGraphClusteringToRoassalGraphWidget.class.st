Class {
	#name : #AlceGraphClusteringToRoassalGraphWidget,
	#superclass : #MiDraggableRoassalWidget,
	#instVars : [
		'cluster',
		'graphToRoassal',
		'clusteringAlgorithm'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphWidget >> canFollowEntity: aModel [

	^ { AlcixModule } anySatisfy: [ :a | aModel isKindOf: a ]
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphWidget >> clusteringAlgorithm: anAlgo [
 	clusteringAlgorithm := anAlgo
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphWidget >> clusteringBehavior [

	
	self clusteringAlgorithm: [ AlceClusteringNearHorizontal new ]
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphWidget >> clusteringState [

	self clusteringAlgorithm: AlceClusteringVariables new
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphWidget >> loadChart: aCanvas withElement: anElement [

	| project classes |
	cluster := clusteringAlgorithm value.
	cluster mooseModel: anElement mooseModel.
	anElement accept: cluster.

	graphToRoassal := AlceGraphToRoassalGraph new
		                  cluster: cluster;
		                  element: anElement;
		                  menuInteraction: self menuInteraction;
		                  yourself.



	project := anElement mooseModel project.


	cluster graph nodes do: [ :node | graphToRoassal processNode: node ].

	classes := self
		           processClassesFrom: graphToRoassal
		           withCluster: cluster.

	aCanvas addAll: classes.

	(anElement isKindOf: AlcixAccessModule) ifFalse: [ 
	aCanvas addAll: graphToRoassal lines.
		 ].
	RSHorizontalLineLayout new on: aCanvas nodes.
	aCanvas @ RSCanvasController.
	^ aCanvas
]

{ #category : #initialization }
AlceGraphClusteringToRoassalGraphWidget >> menuInteraction [

	^ RSMenuActivable new
		  menuDo: [ :menu :aShape | 
			  AlceGraphAbstractMenuItem
				  buildIn: menu
				  shape: aShape
				  visualization: self ];
		  yourself
]

{ #category : #'as yet unclassified' }
AlceGraphClusteringToRoassalGraphWidget >> processClassesFrom: anAlceGraphToRoassalGraph withCluster: anAlceClusteringVariables [

	| clazzes clazz secondaryArch mainArch |
	clazzes := OrderedCollection new.

	anAlceGraphToRoassalGraph architectureComposites keysAndValuesDo: [ 
		:class 
		:archs | 
		(class isKindOf: AlcixModule) ifTrue: [ 
			archs do: #postAdd.
			clazz := RSTitledComposite new.
			clazzes add: clazz.
			clazz layout: RSHorizontalLineLayout new.
			clazz title: class container name , '.' , class name.
			mainArch := (archs sort: #size descending) first.
			secondaryArch := RSLayoutedComposite new.
			secondaryArch addAll: (archs reject: [ :a | a = mainArch ]).
			clazz
				add: mainArch;
				add: secondaryArch.
			clazz color: mainArch color.
			clazz announcer: anAlceGraphToRoassalGraph nodeAnnouncer.
			clazz ] ].
	^ clazzes
]
