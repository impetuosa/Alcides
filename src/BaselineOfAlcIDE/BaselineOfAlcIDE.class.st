Class {
	#name : #BaselineOfAlcIDE,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlcIDE
}

{ #category : #baselines }
BaselineOfAlcIDE >> baseline: spec [

	<baseline>
	"spec
		baseline: #Hooves
		with: [ spec repository: 'github://moosetechnology/Hooves/src' ]."
	spec
		baseline: #Alce
		with: [ spec repository: 'github://impetuosa/Alce/src' ].
	spec package: #AlcIDE with: [ spec requires: #( "Hooves" Alce ) ]
]
