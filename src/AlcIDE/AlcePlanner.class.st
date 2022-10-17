Class {
	#name : #AlcePlanner,
	#superclass : #Object,
	#instVars : [
		'model',
		'metrics'
	],
	#category : #'AlcIDE-Planning'
}

{ #category : #'as yet unclassified' }
AlcePlanner >> generatePlanFor: aModel [

	| all |
	model := aModel.
	metrics := model metrics.
	all := self visitCollection: aModel references.
	^ all
]

{ #category : #'as yet unclassified' }
AlcePlanner >> generatePlanFor: anAlcixModel into: aString [

	| plan write |
	plan := self generatePlanFor: anAlcixModel.
	plan := (plan reject: #isArray) asDictionary.
	aString asFileReference ensureCreateDirectory.
	plan associationsDo: [ :modEntry | 
		write := (aString asFileReference / modEntry name , #csv) writeStream.
		modEntry value do: [ :a | 
			a associationsDo: [ :assoc | 
				write
					nextPutAll: assoc key;
					nextPutAll: ';';
					nextPutAll: assoc value asFloat asString;
					nextPutAll: String crlf ] ].
			write flush; close  ]
]

{ #category : #visiting }
AlcePlanner >> visitAccessModule: anAlcixAccessModule [

	| forms modules classModules reports |
	forms := (anAlcixAccessModule forms accept: self) asDictionary.
	reports := (anAlcixAccessModule reports accept: self) asDictionary.
	modules := (anAlcixAccessModule modules accept: self) asDictionary.
	classModules := (anAlcixAccessModule classModules accept: self)
		                asDictionary.
	^ anAlcixAccessModule name -> ({ 
		   forms.
		   reports.
		   modules.
		   classModules } reject: #isEmpty)
]

{ #category : #visiting }
AlcePlanner >> visitClass: anAlcixClass [

	^ self visitForm: anAlcixClass
]

{ #category : #'7' }
AlcePlanner >> visitCollection: aCollection [

	^ aCollection collect: [ :a | a accept: self ]
]

{ #category : #visiting }
AlcePlanner >> visitForm: anAlcixForm [

	| base ratios number |
	base := metrics metricsFor: anAlcixForm.
	number := anAlcixForm name -> (base children
		           select: [ :a | a isKindOf: MTRAstMetric ]
		           thenCollect: [ :a | 
			           a name = '__INITIALIZE_WIDGET_FROM_UI_CONFIGURATION'
				           ifTrue: [ a tanglingLanguageReferencesRatios at: 2 ]
				           ifFalse: [ 
					           a isExternal
						           ifTrue: [ 300 ]
						           ifFalse: [ 
							           ratios := a grammaticalRatios first.
							           (a tanglingLanguageReferencesRatios at: 2)
							           + (ratios at: 1) + ((ratios at: 2) / 2) * a loc ] ] ])
		          sum.
	^ number = 0
		  ifTrue: [ base loc ]
		  ifFalse: [ number ]
]

{ #category : #visiting }
AlcePlanner >> visitLibrary: anAlcixLibrary [

	^ {  }
]

{ #category : #visiting }
AlcePlanner >> visitModule: anAlcixModule [

	^ self visitForm: anAlcixModule
]

{ #category : #visiting }
AlcePlanner >> visitReport: anAlcixReport [

	^ self visitForm: anAlcixReport
]
