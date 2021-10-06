Class {
	#name : #AlceTextModelComposer,
	#superclass : #AlceTextComposer,
	#instVars : [
		'browsing'
	],
	#category : #'AlcIDE-Text '
}

{ #category : #adding }
AlceTextModelComposer >> addAttributeTypePaint: aColor from: aFrom to: anInteger [

	aFrom > text size ifTrue: [ ^ self ].


	text
		addAttribute: (TextBackgroundColor color: aColor)
		from: aFrom
		to: (anInteger min: text size)
]

{ #category : #adding }
AlceTextModelComposer >> addInspectAction: anAlcixAttribute info: printString from: aFrom to: aTo [

	aFrom > aTo ifTrue: [ ^ self ].
	aFrom > text size ifTrue: [ ^ self ].

	text
		addAttribute: (AlceTextAction
				 block: [ browsing browse: anAlcixAttribute ]
				 info: printString)
		from: aFrom
		to: (aTo min: text size).
	text
		addAttribute: (TextColor color: Color black)
		from: aFrom
		to: (aTo min: text size)
]

{ #category : #'as yet unclassified' }
AlceTextModelComposer >> colorFor: anEntity [

	^ style coloringStrategy colorFor: anEntity
]

{ #category : #'as yet unclassified' }
AlceTextModelComposer >> compose: aVBModuleNode model: anAlcixClass style: anAlceVBAStyle into: aCollection browsingWith: aBrowsingObject [

	browsing := aBrowsingObject.
	text := aCollection.
	ast := aVBModuleNode.
	model := anAlcixClass.
	style := anAlceVBAStyle.
	anAlcixClass accept: self
]

{ #category : #'as yet unclassified' }
AlceTextModelComposer >> paintWithType: anAlcixAttributeOrCollection [

	| thingie |
	thingie := anAlcixAttributeOrCollection isCollection
		           ifTrue: [ anAlcixAttributeOrCollection ]
		           ifFalse: [ { anAlcixAttributeOrCollection } ].
	thingie do: [ :anAlcixAttribute | 
		(anAlcixAttribute anchor isNotNil and: [ 
			 anAlcixAttribute anchor containsSource ]) ifFalse: [ ^ self ].
		self
			addAttributeTypePaint: (self colorFor: anAlcixAttribute)
			from: anAlcixAttribute anchor srcFrom
			to: anAlcixAttribute anchor srcTo ]
]

{ #category : #'as yet unclassified' }
AlceTextModelComposer >> paintWithType: anAlcixAttributeOrCollection from: from to: to [

	| thingie |
	thingie := anAlcixAttributeOrCollection isCollection
		           ifTrue: [ anAlcixAttributeOrCollection ]
		           ifFalse: [ { anAlcixAttributeOrCollection } ].
	thingie do: [ :anAlcixAttribute | 
		self
			addAttributeTypePaint: (self colorFor: anAlcixAttribute)
			from: from
			to: to ]
]

{ #category : #visiting }
AlceTextModelComposer >> splitting: aSideSelector colors: anAlcixAccessRead gap: gap [

	^ self
		  splitting: aSideSelector
		  colors: anAlcixAccessRead
		  gap: gap
		  from: anAlcixAccessRead anchor srcFrom
		  to: anAlcixAccessRead anchor srcTo
]

{ #category : #visiting }
AlceTextModelComposer >> splitting: aSideSelector colors: anAlcixAccessRead gap: gap from: from to: to [

	| leftTo rightFrom |
	(anAlcixAccessRead perform: aSideSelector asSymbol) ifNil: [ ^ self ].
	gap = 0 ifTrue: [ 
		^ self
			  paintWithType:
			  (anAlcixAccessRead perform: aSideSelector asSymbol)
			  from: from
			  to: to ].
	leftTo := from + gap - 1.
	rightFrom := leftTo + 1.

	self
		addAttributeTypePaint:
			((anAlcixAccessRead perform: aSideSelector asSymbol)
				 ifNotNil: [ :n | self colorFor: n first ]
				 ifNil: [ self colorFor: anAlcixAccessRead ])
		from: from
		to: leftTo.

	self
		addAttributeTypePaint:
			((anAlcixAccessRead perform: aSideSelector asSymbol)
				 ifNotNil: [ :n | self colorFor: n first ]
				 ifNil: [ self colorFor: anAlcixAccessRead ])
		from: rightFrom
		to: to
]

{ #category : #visiting }
AlceTextModelComposer >> visitAccess: anAlcixAccessRead [

	| gap |

	anAlcixAccessRead anchor ifNil: [ ^ self ].
	anAlcixAccessRead anchor containsSource ifFalse: [ ^ self ].
	gap := ((anAlcixAccessRead anchor srcFrom to:
	         anAlcixAccessRead anchor srcTo) collect: [ :i | text at: i ]) 
		       lastIndexOf: $..

	self
		addInspectAction: anAlcixAccessRead candidate
		info: ''
		from: anAlcixAccessRead anchor srcFrom
		to: anAlcixAccessRead anchor srcTo.

	self splitting: #candidates colors: anAlcixAccessRead gap: gap
]

{ #category : #visiting }
AlceTextModelComposer >> visitAssignment: anAlcixAccessWrite [

	| gap chain |
	anAlcixAccessWrite anchor containsSource ifFalse: [ ^ self ].
	chain := '' join: ((anAlcixAccessWrite anchor srcFrom to:
		           anAlcixAccessWrite anchor srcTo) collect: [ :i | 
			          text at: i ]).
	gap := chain indexOf: $=.
	chain := '=' split: chain.
	chain size = 2 ifFalse: [ ^ self ].

	self
		addInspectAction: anAlcixAccessWrite writeElement
		info: ''
		from: anAlcixAccessWrite anchor srcFrom
		to: anAlcixAccessWrite anchor srcFrom + gap.

	self
		addInspectAction: anAlcixAccessWrite readElements
		info: ''
		from: anAlcixAccessWrite anchor srcFrom + gap + 1
		to: anAlcixAccessWrite anchor srcTo.


	self
		splitting: #writeElementCandidates
		colors: anAlcixAccessWrite
		gap: (chain first lastIndexOf: $.)
		from: anAlcixAccessWrite anchor srcFrom
		to: anAlcixAccessWrite anchor srcFrom + gap.

	self
		splitting: #readElementsCandidates
		colors: anAlcixAccessWrite
		gap: (chain second lastIndexOf: $.)
		from: anAlcixAccessWrite anchor srcFrom + gap + 1
		to: anAlcixAccessWrite anchor srcTo.

	anAlcixAccessWrite writeElement do: [ :e | e accept: self ].
	anAlcixAccessWrite readElements do: [ :e | e accept: self ]
]

{ #category : #visiting }
AlceTextModelComposer >> visitAttribute: anAlcixAttribute [
	self paintWithType: anAlcixAttribute.
	
]

{ #category : #visiting }
AlceTextModelComposer >> visitAttributeAccessor: anAlcixAttributeAccessor [ 
 	 self visitFunction: anAlcixAttributeAccessor 
]

{ #category : #visiting }
AlceTextModelComposer >> visitClass: anAlcixClass [ 
	self visitModule: anAlcixClass.
]

{ #category : #visiting }
AlceTextModelComposer >> visitCollection: aCollection [

	aCollection do: [ :a | a accept: self ]
]

{ #category : #visiting }
AlceTextModelComposer >> visitConstant: anAlcixConstant [ 
	
]

{ #category : #visiting }
AlceTextModelComposer >> visitEnum: anAlcixEnum [ 
		
]

{ #category : #visiting }
AlceTextModelComposer >> visitEvent: anAlcixEvent [

	^ self visitSubProcedure: anAlcixEvent
]

{ #category : #visiting }
AlceTextModelComposer >> visitExternalFunction: anAlcixExternalFunction [

	self visitFunction: anAlcixExternalFunction
]

{ #category : #visiting }
AlceTextModelComposer >> visitExternalSubProcedure: anAlcixExternalSubProcedure [

	^ self visitSubProcedure: anAlcixExternalSubProcedure
]

{ #category : #visiting }
AlceTextModelComposer >> visitForm: anAlcixForm [

	self visitClass: anAlcixForm
]

{ #category : #visiting }
AlceTextModelComposer >> visitFunction: anAlcixFunction [

	| typeAnchorFrom typeAnchorTo fn |
	self visitSubProcedure: anAlcixFunction.

	fn := ast elements detect: [ :f | 
		      ((f isKindOf: VBFunctionDefinitionNode) or: [ 
			       f isKindOf: VBModulePropertyGetNode ]) and: [ 
			      f selector token value = anAlcixFunction selector ] ].

	anAlcixFunction type ifNil: [ ^ self ].
	fn type ifNil: [ ^ self ].

	typeAnchorFrom := fn type type startPosition.
	typeAnchorTo := fn type type stopPosition.


	self
		addInspectAction: anAlcixFunction type
		info: anAlcixFunction type printString
		from: typeAnchorFrom
		to: typeAnchorTo.
	self
		addAttributeTypePaint: (self colorFor: anAlcixFunction type)
		from: typeAnchorFrom
		to: typeAnchorTo
]

{ #category : #visiting }
AlceTextModelComposer >> visitInvocation: anAlcixInvocation [

	anAlcixInvocation anchor ifNil: [ ^ self ].
	
	self
		addInspectAction: anAlcixInvocation candidate
		info: anAlcixInvocation printString
		from: anAlcixInvocation anchor srcFrom
		to: anAlcixInvocation anchor srcFrom
			+ anAlcixInvocation selector adaptToAlceAnchorPathFragment size.

	self
		addAttributeTypePaint: (self colorFor: anAlcixInvocation)
		from: anAlcixInvocation anchor srcFrom
		to: anAlcixInvocation anchor srcFrom
			+ anAlcixInvocation selector adaptToAlceAnchorPathFragment size
]

{ #category : #visiting }
AlceTextModelComposer >> visitLocalVariable: anAlcixLocalVariable [

	self paintWithType: anAlcixLocalVariable
]

{ #category : #visiting }
AlceTextModelComposer >> visitMethodInvocation: anAlcixMethodInvocation [

	self paintWithType: anAlcixMethodInvocation
]

{ #category : #visiting }
AlceTextModelComposer >> visitModule: anAlcixClass [

	self visitCollection: anAlcixClass members.
	self visitCollection: anAlcixClass invocables.
	self visitCollection: anAlcixClass types
]

{ #category : #visiting }
AlceTextModelComposer >> visitParameter: anAlcixParameter [

	self paintWithType: anAlcixParameter
]

{ #category : #visiting }
AlceTextModelComposer >> visitReport: anAlcixReport [

	^ self visitClass: anAlcixReport
]

{ #category : #visiting }
AlceTextModelComposer >> visitSubProcedure: anAlcixSubProcedure [

	self visitCollection: anAlcixSubProcedure parameters.
	self visitCollection: anAlcixSubProcedure localVariables.
	self visitCollection: anAlcixSubProcedure constants.
	self visitCollection: anAlcixSubProcedure outgoingAccesses.
	self visitCollection: anAlcixSubProcedure assignments
]

{ #category : #visiting }
AlceTextModelComposer >> visitUserType: anAlcixUserType [

	self visitCollection: anAlcixUserType members
]
