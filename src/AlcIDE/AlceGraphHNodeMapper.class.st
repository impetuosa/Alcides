Class {
	#name : #AlceGraphHNodeMapper,
	#superclass : #AlceGraphMapper,
	#instVars : [
		'allHNodes',
		'root'
	],
	#category : #'AlcIDE-Clustering'
}

{ #category : #building }
AlceGraphHNodeMapper >> build [
	self mapAllNodes. 
	self applyRelationRepresentations. 
	self buildRoot. 
	^ root 
	
]

{ #category : #building }
AlceGraphHNodeMapper >> buildRoot [
	root := HNode new. 
	root name:#Root. 
	root children: mappeEntities 
]

{ #category : #'as yet unclassified' }
AlceGraphHNodeMapper >> defaultEntityMapperBlock [

	^ [ :e | 
	  HNode new
		  rawModel: e;
		  name: e name;
		  yourself ]
]

{ #category : #'as yet unclassified' }
AlceGraphHNodeMapper >> hnodeForEntity: anEntity [

	^ allHNodes detect: [ :s | s rawModel = anEntity ]
]

{ #category : #'as yet unclassified' }
AlceGraphHNodeMapper >> mapAllNodes [
	super mapAllNodes .
	allHNodes := mappeEntities copy
]
