Class {
	#name : #RSTitledComposite,
	#superclass : #RSLayoutedComposite,
	#instVars : [
		'title',
		'mychildren'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #initialization }
RSTitledComposite >> add: aChild [

	mychildren add: aChild.
	self postAdd
]

{ #category : #initialization }
RSTitledComposite >> border: aBorder [

	super border: aBorder.
	mychildren border: aBorder
]

{ #category : #initialization }
RSTitledComposite >> color [

	^ title settingColor
]

{ #category : #initialization }
RSTitledComposite >> color: aColor [
	mychildren border color: aColor.
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
	mychildren := RSLayoutedComposite new.
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
		add: mychildren
]

{ #category : #initialization }
RSTitledComposite >> layout: aLayout [

	mychildren layout: aLayout
]

{ #category : #initialization }
RSTitledComposite >> postAdd [

	mychildren postAdd.
	parent ifNotNil: [ 
		(parent respondsTo: #noteChildAdded) ifTrue: [ 
			parent noteChildAdded ] ].
	layout on: { 
			title.
			mychildren }.
	self adjustToChildren.


	title setExtent: self extent x @ title extent y.
	layout on: { 
			title.
			mychildren }.
	self adjustToChildren
]

{ #category : #initialization }
RSTitledComposite >> silentAdd: aChild [

	mychildren silentAdd: aChild.

]

{ #category : #initialization }
RSTitledComposite >> size [

	^ mychildren size 
]

{ #category : #initialization }
RSTitledComposite >> title: aText [
 	 title text: aText. 
]
