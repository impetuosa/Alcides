Class {
	#name : #RSTitledComposite,
	#superclass : #RSLayoutedComposite,
	#instVars : [
		'title',
		'children'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #initialization }
RSTitledComposite >> add: aChild [

	children add: aChild.
	self postAdd
]

{ #category : #initialization }
RSTitledComposite >> border: aBorder [

	super border: aBorder.
	children border: aBorder
]

{ #category : #initialization }
RSTitledComposite >> color [

	^ title settingColor
]

{ #category : #initialization }
RSTitledComposite >> color: aColor [
	children border color: aColor.
	title settingColor: aColor
]

{ #category : #initialization }
RSTitledComposite >> cornerRadius [
	^ 7
]

{ #category : #initialization }
RSTitledComposite >> initialize [

	super initialize.
	title := RSTitle new.
	title settingColor: Color green.
	children := RSLayoutedComposite new.
	self border: (RSBorder new
			 width: 1;
			 color: Color black muchDarker;
			 capRound;
			 yourself).
	layout := RSVerticalLineLayout new
		          gapSize: 0;
		          alignLeft;
		          yourself.
	super
		add: title;
		add: children
]

{ #category : #initialization }
RSTitledComposite >> layout: aLayout [

	children layout: aLayout
]

{ #category : #initialization }
RSTitledComposite >> postAdd [

	children postAdd.
	parent ifNotNil: [ 
		(parent respondsTo: #noteChildAdded) ifTrue: [ 
			parent noteChildAdded ] ].
	layout on: { 
			title.
			children }.
	self adjustToChildren.


	title setExtent: self extent x @ title extent y.
	layout on: { 
			title.
			children }.
	self adjustToChildren
]

{ #category : #initialization }
RSTitledComposite >> silentAdd: aChild [

	children silentAdd: aChild.

]

{ #category : #initialization }
RSTitledComposite >> size [

	^ children size 
]

{ #category : #initialization }
RSTitledComposite >> title: aText [
 	 title text: aText. 
]
