Class {
	#name : #AlceGrammarRatioWidget,
	#superclass : #AlceMetricRatioWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceGrammarRatioWidget class >> runMe [
	<script>
	^ super runMe
]

{ #category : #specs }
AlceGrammarRatioWidget class >> title [

	^ 'Grammar Ratio'
]

{ #category : #visiting }
AlceGrammarRatioWidget >> calculateObjectsFor: element [

	| baseline |
	baseline := metrics grammaticalRatios.

	^ { 
		  (#Incompatible -> (baseline collect: #first) sum).
		  (#Compatible -> (baseline collect: #second) sum) } asDictionary
]
