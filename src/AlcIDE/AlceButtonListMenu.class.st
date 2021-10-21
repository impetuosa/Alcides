Class {
	#name : #AlceButtonListMenu,
	#superclass : #SpPresenter,
	#instVars : [
		'menu',
		'buttons'
	],
	#category : #'AlcIDE-Menu'
}

{ #category : #specs }
AlceButtonListMenu class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #menu width: 110;
				   yourself);
		  yourself
]

{ #category : #specs }
AlceButtonListMenu class >> open [
	<script> 
	self new openWithSpec 
]

{ #category : #initialization }
AlceButtonListMenu >> buttonsToAddToTheMenu [

	| col |
	col := OrderedCollection new.
	col add: ((self instantiate: AlcePopOverMenuButton)
			 icon: MooseIcons mooseBars;
			 name: #Frequencies;
			 actions: self frequenceActions;
			 yourself).
	col add: ((self instantiate: AlcePopOverMenuButton)
			 icon: MooseIcons mooseBars;
			 name: #Ratios;
			 actions: self ratiosActions;
			 yourself).
	col add: ((self instantiate: AlcePopOverMenuButton)
			 icon: MooseIcons mooseBars;
			 name: #Hierarchical;
			 actions: self hierarhicalActions;
			 yourself).
	col add: ((self instantiate: AlcePopOverMenuButton)
			 icon: MooseIcons mooseBars;
			 name: #Complexity;
			 actions: self complexityActions;
			 yourself).
	col add: ((self instantiate: AlcePopOverMenuButton)
			 icon: MooseIcons mooseBars;
			 name: #Source;
			 actions: self codeActions;
			 yourself).
	col add: ((self instantiate: AlcePopOverMenuButton)
			 icon: MooseIcons mooseBars;
			 name: #Model;
			 actions: self modelActions;
			 yourself).
	^ col reverse
]

{ #category : #initialization }
AlceButtonListMenu >> codeActions [

	^ { 
		  (AlceAction new
			   name: 'Outline';
			   action: [ AlceOutlineTree runDragMe ]).
		  (AlceAction new
			   name: 'Usages';
			   action: [ AlceUsersTree runDragMe ]).
		  (AlceAction new
			   name: 'Functions Subs & Properties inspector';
			   action: [ AlceInvocableWidget runDragMe ]).
		  (AlceAction new
			   name: 'Source Code';
			   action: [ AlceSourceCodeWidget runDragMe ]) }
]

{ #category : #initialization }
AlceButtonListMenu >> complexityActions [

	^ { (AlceAction new
		   name: 'Tangling Complexity';
		   action: [ AlceTanglingComplexityHighlight runMe ]) }
]

{ #category : #initialization }
AlceButtonListMenu >> frequenceActions [

	^ { (AlceAction new
			   name: 'Grammatical';
			   action: [ AlceComplexGrammaticalConstructionFrequency runDragMe ]).

		  (AlceAction new
			   name: 'Paradigmatic';
			   action: [ AlceIncompatibleParadigmaticEntitiesFrequency runDragMe ]).

		  (AlceAction new
			   name: 'Tangling';
			   action: [ AlceReferenceTanglingFrequency runDragMe ]) }
]

{ #category : #initialization }
AlceButtonListMenu >> hierarhicalActions [

	^ { 
		  (AlceAction new
			   name: 'Architectural Distribution';
			   action: [ AlceTagDistribution runDragMe ]).

		  (AlceAction new
			   name: 'Architectural Dependencies';
			   action: [ AlceTagHierachical runDragMe ]) }
]

{ #category : #initialization }
AlceButtonListMenu >> initializePresenters [

	super initializePresenters.

	buttons := self buttonsToAddToTheMenu.

	menu := self newComponentList.

	menu presenters: buttons
]

{ #category : #initialization }
AlceButtonListMenu >> modelActions [

	^ { 
		  (AlceAction new
			   name: 'Choose Coloring Strategy';
			   presenter: AlceColorStrategySelectorWidget;
			   action: [  ]).
		  (AlceAction new
			   name: 'Open Model';
			   action: [ 
				   MiApplication current buses do: [ :b | 
						   b refreshBrowsersWith: MooseModelRoot root entities anyOne ] ]) }
]

{ #category : #initialization }
AlceButtonListMenu >> newPopoverButton [

	| b |
	b := self instantiate: AlcePopOverMenuButton.
	buttons add: b.
	menu presenters: buttons.
	^ b
]

{ #category : #initialization }
AlceButtonListMenu >> ratiosActions [

	^ { 
		  (AlceAction new
			   name: 'Grammatical';
			   action: [ AlceGrammarRatioWidget runDragMe ]).

		  (AlceAction new
			   name: 'Paradigmatic';
			   action: [ AlceParadigmaticRatioWidget runDragMe ]).

		  (AlceAction new
			   name: 'Tangling';
			   action: [ AlceTagUsageRatioChartWidget runDragMe ]).  }
]
