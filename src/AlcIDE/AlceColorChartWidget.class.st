Class {
	#name : #AlceColorChartWidget,
	#superclass : #AlcePieChartWidget,
	#instVars : [
		'strategies',
		'categories',
		'mooseModel'
	],
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceColorChartWidget class >> defaultSpec [

	^ self basicDefaultSpec
		  add: (SpBoxLayout newLeftToRight
				   add: #strategies;
				   add: #categories)
		  height: 50;
		  add: (SpBoxLayout newLeftToRight
				   add: #reference withConstraints: [ :c | c width: 150 ];
				   add: #viewport);
		  add: #refresh height: self toolbarHeight;
		  yourself
]

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

	(anEntity isKindOf: AlcixModel) ifTrue: [ 
		categories items: anEntity allTagCategories.
		mooseModel := anEntity.
		^ false ].

	^ anEntity isMooseObject
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> calculateObjectsFor: element [

	| baseline |
	element ifNil: [ ^ {  } ].
	baseline := self colorsFor: element.


	^ baseline groupedBy: #yourself
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> coloringStrategyFor: aClass [

	| inst |
	^ mooseModel coloringStrategies
		  detect: [ :a | a class = aClass ]
		  ifNone: [ 
			  inst := aClass new.
			  mooseModel installColoringStrategy: inst.
			  inst ]
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> colorsFor: anAlcixClass [

	^ strategies colorsFor: anAlcixClass
]

{ #category : #visiting }
AlceColorChartWidget >> followAction [

	super followAction.
	toSelect ifNotNil: [ 
		categories items asOrderedCollection = toSelect mooseModel allTagCategories asOrderedCollection ifFalse: [ 
			categories items: toSelect mooseModel allTagCategories ] ]
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> initializePresenters [

	super initializePresenters.
	strategies := self instantiate: AlceColorStrategySelectorWidget.
	strategies strategies: AlceColoringStrategy allSubclasses.
	strategies whenSelectionChangedDo: [ self refresh ].
	strategies creatingInstancesWith: [ :a | self coloringStrategyFor: a ].
	categories := self newDropList.
	categories
		whenSelectionChangedDo: [ 
			strategies selectingCategory: categories selectedItem ];
		display: [ :a | a name ]
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> referenceMaximumFor: element [

	^ element mooseModel size
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> refresh [

	strategies reset.
	super refresh
]

{ #category : #'as yet unclassified' }
AlceColorChartWidget >> scaleForSelectedElement: objects [

	^ ((objects collect: [ :o | o value size ]) ifEmpty: [ { 0 } ]) sum
]
