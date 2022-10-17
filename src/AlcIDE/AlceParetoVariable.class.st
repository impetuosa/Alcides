Class {
	#name : #AlceParetoVariable,
	#superclass : #AlceParetoChart,
	#instVars : [
		'associations'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #initialization }
AlceParetoVariable >> associationCounts [

	^ associations 
]

{ #category : #initialization }
AlceParetoVariable >> associations: assocs [
	associations := assocs 
]

{ #category : #initialization }
AlceParetoVariable >> chartTitle [

	^ 'Usage'
]

{ #category : #initialization }
AlceParetoVariable >> xLabel [

	^ ' #Artefacts '
]

{ #category : #initialization }
AlceParetoVariable >> yLabel [

	^ ' #Usages '
]
