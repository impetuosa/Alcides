Class {
	#name : #AlceGraphAbstractMenuItem,
	#superclass : #Object,
	#instVars : [
		'shape',
		'visualization'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #public }
AlceGraphAbstractMenuItem class >> buildIn: aMenuMorph shape: aRoassalShape visualization: anHSimpleVisualizationBuilder [
	| items |

	items := { HInspectorMenuItem . AlceGraphPropagateMenuItem} collect: #new.
	items := items groupedBy: [ :item | item group ].
	items keys sorted do: [ :key | | group |
		group := (items at: key) sorted: [ :a :b | a order < b order ].
		group do: [ :item | 
			item
				shape: aRoassalShape;
				visualization: anHSimpleVisualizationBuilder;
				buildOn: aMenuMorph ]
		] separatedBy: [ aMenuMorph addSeparator ].
	
]
