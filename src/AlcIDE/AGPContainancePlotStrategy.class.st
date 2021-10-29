Class {
	#name : #AGPContainancePlotStrategy,
	#superclass : #AGPMappingStrategy,
	#instVars : [
		'shapes'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #'as yet unclassified' }
AGPContainancePlotStrategy >> afterApply [

	| inner child rectangle |
	
	shapes do: [ :fromShape |
		
		 
		inner := fromShape innerShape.
		child := fromShape schildren asShape.
		fromShape add: fromShape schildren asShape.
		self layoutOn: fromShape schildren.

		rectangle := child encompassingRectangle.
		fromShape fromRectangle: rectangle.
		rectangle := rectangle extendBy: rectangle extent * 0.25.
		inner fromRectangle: rectangle.

		inner position: fromShape position.
		inner pushBack.

		fromShape adjustToChildren.
		fromShape
			adjustToChildren;
			padding: 10.

		rectangle := child encompassingRectangle.
		rectangle := rectangle extendBy: rectangle extent * 0.3.

		inner fromRectangle: rectangle.
		fromShape position: fromShape encompassingRectangle floatCenter.
		inner position: fromShape encompassingRectangle floatCenter.
		
		
		fromShape
			adjustToChildren;
			padding: 10.
		 ]
]

{ #category : #'as yet unclassified' }
AGPContainancePlotStrategy >> applyInto: anAlceGraphPlotter forRelationFrom: anEntity to: aDestinationEntity [

		| fromShape toShape inner  |
	fromShape := anAlceGraphPlotter shapeForEntity: anEntity.
	fromShape schildren ifNil: [ fromShape schildren: RSGroup new ].
	inner := fromShape innerShape.
	toShape := anAlceGraphPlotter shapeForEntity: aDestinationEntity.
	toShape sparent: fromShape.
	anAlceGraphPlotter removeMappedEntity: toShape.
	fromShape schildren add: toShape.
	
	shapes add: fromShape. 
]

{ #category : #'as yet unclassified' }
AGPContainancePlotStrategy >> beforeApply [ 
	shapes := Set new 
	
]

{ #category : #'as yet unclassified' }
AGPContainancePlotStrategy >> layoutOn: aRSGroup [

	RSGridLayout new on: aRSGroup
]

{ #category : #'as yet unclassified' }
AGPContainancePlotStrategy >> requiresPostApplication [ 
	^ true
]
