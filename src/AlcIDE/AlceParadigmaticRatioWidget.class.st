Class {
	#name : #AlceParadigmaticRatioWidget,
	#superclass : #AlceMetricRatioWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceParadigmaticRatioWidget class >> runMe [
	<script>
	super runMe
]

{ #category : #specs }
AlceParadigmaticRatioWidget class >> title [

	^ 'Paradigmatic Ratio'
]

{ #category : #visiting }
AlceParadigmaticRatioWidget >> calculateObjectsFor: element [

	| baseline |

	baseline := metrics paradigmaticRatios.
	
	
	^ { (#Incompatible -> (baseline collect:#first ) sum ) . (#Compatible -> (baseline collect:#second ) sum )} asDictionary 

]
