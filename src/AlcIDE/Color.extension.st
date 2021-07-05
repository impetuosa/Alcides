Extension { #name : #Color }

{ #category : #'*AlcIDE' }
Color class >> colors [

	^ (ColorRegistry values , IndexedColors) asSet asArray
]
