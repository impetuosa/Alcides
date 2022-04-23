Class {
	#name : #AlceVariableClusteringWidget,
	#superclass : #MiDraggableRoassalWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #initialization }
AlceVariableClusteringWidget >> canFollowEntity: aModel [
	^( aModel isKindOf: AlcixModel ) 
]

{ #category : #initialization }
AlceVariableClusteringWidget >> loadChart: aCanvas withElement: anElement [

	| obje nul mapped p root hi |
	obje := AlceClusteringVariables new.
	obje mooseModel: anElement mooseModel.
	(anElement mooseModel project modules first modules first: 10) do: [ :a | 
		anElement accept: obje ].

	nul := OrderedCollection new.
	mapped := Dictionary new.
	p := anElement mooseModel project.


	mapped values select: [ :a | 
		a parent isNil and: [ (a rawModel = p) not ] ].


	obje graph nodes do: [ :l | 
		| lHnode relations |
		relations := obje graph arcsFromObject: l.
		lHnode := mapped at: l ifAbsentPut: [ 
			          HNode new
				          rawModel: l;
				          name: l name;
				          yourself ].

		relations ifNil: [ nul add: l ] ifNotNil: [ 
			(relations select: [ :r | r name = #architecturalRole ]) do: [ :arc | 
				| ownerx ownerHnode |
				ownerx := arc to readValueFrom: obje graph.
				ownerHnode := mapped at: ownerx ifAbsentPut: [ 
					              HNode new
						              rawModel: ownerx;
						              name: ownerx name;
						              yourself ].
				ownerHnode addChild: lHnode ].

			(relations select: [ :r | r name = #belongsTo ]) do: [ :arc | 
				| ownerx ownerHnode |
				ownerx := arc to readValueFrom: obje graph.
				ownerHnode := mapped at: ownerx ifAbsentPut: [ 
					              HNode new
						              rawModel: ownerx;
						              name: ownerx name;
						              yourself ].
				ownerHnode dependencyTo: lHnode ] ] ].


	root := HNode new
		        name: #Root;
		        children: (mapped values select: [ :a | 
					         a parent isNil and: [ (a rawModel = p) not ] ]).

	hi := HSimpleVisualizationBuilder new.
	hi rootNode: root.
	hi container: aCanvas.
	aCanvas @ RSCanvasController.
	hi open
]
