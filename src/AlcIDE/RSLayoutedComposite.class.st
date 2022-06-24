Class {
	#name : #RSLayoutedComposite,
	#superclass : #RSComposite,
	#instVars : [
		'layout'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #adding }
RSLayoutedComposite >> add: aChild [

	super add: aChild.
	self pushFront: aChild.
	self postAdd. 
	
]

{ #category : #adding }
RSLayoutedComposite >> layout [

	^ layout ifNil: [ 
		  RSVerticalLineLayout new
			  gapSize: 1;
			  yourself ]
]

{ #category : #accessing }
RSLayoutedComposite >> layout: aRSSimpleForceBasedLayout [ 
	layout := aRSSimpleForceBasedLayout
]

{ #category : #initialization }
RSLayoutedComposite >> noteChildAdded [

	self postAdd.
	parent ifNotNil: [ 
		(parent respondsTo: #noteChildAdded) ifTrue: [ 
			parent noteChildAdded ] ]
]

{ #category : #adding }
RSLayoutedComposite >> postAdd [

	children ifNotNil: [ 
		self layout on: children.
		self adjustToChildren.
		self extent: self extent + 10 ]
]

{ #category : #adding }
RSLayoutedComposite >> shapeWithAction: eventClass forPosition: position [

	| res pos |
	(self includesPoint: position) ifTrue: [ 
		pos := self matrix rsInverseTransform: position.
		self shapes reverseDo: [ :s | 
			res := s shapeWithAction: eventClass forPosition: pos.
			res ifNotNil: [ ^ res ] ] ].
	^ (self hasEventCallback and: [ 
		   (self announcer handleEventClass: eventClass) and: [ 
			   self includesPoint: position ] ])
		  ifTrue: [ self ]
		  ifFalse: [ nil ]
]

{ #category : #initialization }
RSLayoutedComposite >> silentAdd: aChild [

	super add: aChild.

]

{ #category : #adding }
RSLayoutedComposite >> size [

	^ children size
]
