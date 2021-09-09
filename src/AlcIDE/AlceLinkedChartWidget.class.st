Class {
	#name : #AlceLinkedChartWidget,
	#superclass : #AlcePieChartWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlceLinkedChartWidget class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcLinkChartBrowser)
		parent: self alceBrowsers;
		label: (self title);
		icon: (self iconNamed: #mooseTree); 
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceLinkedChartWidget class >> runMe [
	<script>
	super runMe
]

{ #category : #accessing }
AlceLinkedChartWidget class >> title [

	^ 'Alce Linking element Browser'
]

{ #category : #visiting }
AlceLinkedChartWidget >> accept: anEntity [

	^ { AlcixModel } anySatisfy: [ :a | anEntity isKindOf: a ]
]

{ #category : #'as yet unclassified' }
AlceLinkedChartWidget >> calculateObjectsFor: element [

	| group |
	buffer at: element ifPresent: [ :v | ^ v ].
	"groupedBy: [ 
			   :e | self colorFor: e ]) values"

	group := Dictionary new.
	group inspect.
	group at: Color red put: OrderedCollection new.
	group at: Color green put: OrderedCollection new.


	(element allWithType: AlcixAccess) do: [ :e | 
		((e candidates anySatisfy: [ :c | c isUnknown ])
			 ifTrue: [ group at: Color red ]
			 ifFalse: [ group at: Color green ]) add: e ].

	(element allUsing: AlcixTTyped) do: [ :e | 
		(e type isUnknown
			 ifTrue: [ group at: Color red ]
			 ifFalse: [ group at: Color green ]) add: e ].

	buffer at: element put: group associations.
	^ group associations
]

{ #category : #'as yet unclassified' }
AlceLinkedChartWidget >> referenceMaximumFor: element [

	^ ((self calculateObjectsFor: element)  collect: [ :c | c value size ])
		  sum
]

{ #category : #'as yet unclassified' }
AlceLinkedChartWidget >> scaleForSelectedElement: objects [

	^ objects size
]
