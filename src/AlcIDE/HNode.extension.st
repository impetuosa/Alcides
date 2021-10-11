Extension { #name : #HNode }

{ #category : #'*AlcIDE' }
HNode >> allChildren [

	^ { children } , (children flatCollect: [ :c | c allChildren ])
]
