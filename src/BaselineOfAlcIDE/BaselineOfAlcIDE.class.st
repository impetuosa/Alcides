Class {
	#name : #BaselineOfAlcIDE,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlcIDE
}

{ #category : #baselines }
BaselineOfAlcIDE >> baseline: spec [
	<baseline>
	spec
		project: #SimpleDDS
		with: [ spec repository: 'github://pharo-robotics/SimpleDDS/src' ].
	spec
		project: #Alce
		with: [ spec repository: 'github://impetuosa/Alce/src' ].
	spec package: #AlcIDE with: [ spec requires: #(SimpleDDS Alce) ].
	
]
