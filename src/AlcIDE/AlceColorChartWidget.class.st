Class {
	#name : #AlceColorChartWidget,
	#superclass : #AlcePieChartWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #'world menu' }
AlceColorChartWidget class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alcTagChartBrowser)
		parent: AlcIDE alceBrowsers;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #specs }
AlceColorChartWidget class >> runMe [
	<script>
	super runMe
]

{ #category : #accessing }
AlceColorChartWidget class >> title [

	^ 'Alce Tag Browser'
]

{ #category : #visiting }
AlceColorChartWidget >> accept: anEntity [
	^ { 
		  AlcixModel.
		  AlcixContainer } anySatisfy: [ :a | anEntity isKindOf: a ]
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> calculateObjectsFor: element [

	| baseline group |
	buffer at: element ifPresent: [ :v | ^ v ].
	"groupedBy: [ 
			   :e | self colorFor: e ]) values"
	(element isKindOf: AlcixModel) ifTrue: [ 
		baseline := element select: [ :e | e isKindOf: AlcixModule ] ].

	(element isKindOf: AlcixContainer) ifTrue: [ baseline := { element } ].
	(element isKindOf: AlcixReference) ifTrue: [ 
		baseline := element types ].
	group := Dictionary new.
	baseline do: [ :e | 
		(self colorsFor: e) do: [ :c | 
			(group at: c ifAbsentPut: [ OrderedCollection new ]) add: e ] ].
	baseline size = 1 ifFalse: [ 
		buffer at: element put: group associations ].
	^ group associations
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> referenceMaximumFor: element [

	^ element mooseModel size
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> scaleForSelectedElement: objects [

	^ ((objects flatCollect: [ :o | o value collect: #weight ]) ifEmpty: [ 
		   { 0 } ]) sum
]
