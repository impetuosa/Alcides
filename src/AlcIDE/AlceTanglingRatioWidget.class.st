Class {
	#name : #AlceTanglingRatioWidget,
	#superclass : #AlceMetricRatioWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceTanglingRatioWidget class >> runMe [
	<script>
		self error:'d onot use.'. 
	^ super runMe
]

{ #category : #specs }
AlceTanglingRatioWidget class >> title [

	^ 'Paradigmatic Ratio'
]

{ #category : #visiting }
AlceTanglingRatioWidget >> calculateObjectsFor: element [

	| baseline dependancies astSizes |

	baseline := metrics referencesTanglingRatios asDictionary.
	baseline := baseline asDictionary.
	dependancies := (baseline values collect: #second) sum.
	astSizes := (baseline collect: #first) sum.


	^ { 
		  (#LibraryDependant -> dependancies).
		  (#NonLibraryDependant -> (astSizes - dependancies)) } asDictionary
]
