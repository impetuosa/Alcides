Class {
	#name : #RSTitle,
	#superclass : #RSComposite,
	#instVars : [
		'title',
		'label',
		'text',
		'icon',
		'iconBitMap',
		'settingColor',
		'titleBox',
		'textColor',
		'topCornerRadius',
		'titleGroup'
	],
	#category : #'AlcIDE-GraphWidgets'
}

{ #category : #initialization }
RSTitle >> buildTitle [

	titleGroup := RSGroup new.
	self icon ifNotNil: [ titleGroup add: self icon ].
	titleGroup add: self label.
	RSHorizontalLineLayout new
		alignMiddle;
		on: titleGroup.

	RSHorizontalLineLayout new
		alignMiddle;
		on: titleGroup.

	titleBox := RSBox new
		            extent: titleGroup extent + 10;
		            color: self settingColor;
		            position: titleGroup position;
		            border: (RSBorder new
				             color: Color black muchDarker;
				             width: 1;
				             yourself) yourself.
	self
		add: titleBox;
		addAll: titleGroup;
		adjustToChildren
]

{ #category : #initialization }
RSTitle >> fullCornerRadius [

	^ titleBox cornerRadius: (RSCornerRadius new radius: 7)
]

{ #category : #initialization }
RSTitle >> icon [

	icon ifNil: [ ^ nil ].
	^ iconBitMap ifNil: [ 
		  iconBitMap := RSBitmap new
			                form: icon;
			                yourself ]
]

{ #category : #initialization }
RSTitle >> icon: anIcon [

	icon := anIcon.
	iconBitMap ifNotNil: [ :i | i form: anIcon ]
]

{ #category : #initialization }
RSTitle >> initialize [ 
	super initialize.
	self buildTitle 
]

{ #category : #initialization }
RSTitle >> label [

	^ label ifNil: [ 
		  label := RSLabel new
			           color: self textColor;
			           text: self text;
			           fontName: 'Source Sans Pro';
			           fontSize: 12;
			           yourself ]
]

{ #category : #initialization }
RSTitle >> setExtent: anExtent [

	titleBox extent: anExtent.
	self extent: anExtent.
	self adjustToChildren
]

{ #category : #initialization }
RSTitle >> settingColor [

	^ (settingColor ifNil: [ Color transparent ]) alpha: 0.7
]

{ #category : #initialization }
RSTitle >> settingColor: aColor [

	settingColor := aColor.
	titleBox ifNotNil: [ titleBox color: self settingColor ]
]

{ #category : #initialization }
RSTitle >> shapeWithAction: eventClass forPosition: position [

	| res pos |
	(self encompassingRectangle containsPoint: position) ifTrue: [ 
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
RSTitle >> text [

	^ text ifNil: [ ^ 'Empty ' ]
]

{ #category : #initialization }
RSTitle >> text: aText [

	label ifNotNil: [ :l | 
		l text: aText.

		self setExtent: titleGroup extent + 10 ].
	text := aText
]

{ #category : #initialization }
RSTitle >> textColor [

	^ textColor ifNil: [ Color black muchDarker ]
]

{ #category : #initialization }
RSTitle >> textColor: aTextColor [

	textColor := aTextColor.
	label ifNotNil: [ label color: self textColor ]
]

{ #category : #initialization }
RSTitle >> topCornerRadius [

	^ titleBox cornerRadius: (RSCornerRadius new top: 7)
]
