# Alcides
IDE extentions for Alce


mooseModel := AlcixModel  allInstances anyOne.

obje := AlceClusteringFunction new .
obje mooseModel: mooseModel. 
(mooseModel project modules first modules select: [: a | a name = 'Utilities' ]) do: [ :a |  a accept: obje ].

	
(plotter := AlceGraphHNodeMapper new
	graph: obje graph;
	doNotMap: [  : node | node isKindOf:Color ];
	representReverseRelationNamed: #architecturalRole with: AGPMappingStrategy hnodeContainanceStrategy; 
	representRelationNamed: #belongsTo with: AGPMappingStrategy hnodeDependenceStrategy;
	representRelationNamed: #architecturalColor with: AGPMappingStrategy hnodecoloringStrategy) .
	plotter build open.
	
	
(plotter := AlceGraphPlotter new
	graph: obje graph;
	shapesLayout: RSGridLayout ;
	interactionBuildingBlock:  [  : a | a popup;
		@ (GraphGhostDraggable new 
			color: Smalltalk ui theme caretColor);
		@ (GraphOnTopWhenPositionChanged new);
		@ (GraphResizeParentWhenChildMoves new);
		yourself. ];
	defaultEntityBuilder: [:cls | RSEllipse new  popup; model: cls; yourself] ;
	doNotMap: [  : node | node isKindOf:Color ];
	whenEntity:[ : e | e isKindOf: AlcixInvocable ] buildShapeWith: [:cls | | f  | f:=  RSBox new model: cls; popup; yourself.  f ] ;
	representReverseRelationNamed: #architecturalRole with: AGPMappingStrategy containanceStrategy; 
	representRelationNamed: #belongsTo with: AGPMappingStrategy linkingStrategy;
	representRelationNamed: #architecturalColor with: AGPMappingStrategy coloringStrategy) .
	plotter plot open.
