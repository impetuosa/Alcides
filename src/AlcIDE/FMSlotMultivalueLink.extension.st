Extension { #name : #FMSlotMultivalueLink }

{ #category : #'*AlcIDE' }
FMSlotMultivalueLink >> sort: aPropertySortFunction [

	^ self asOrderedCollection sort: aPropertySortFunction
]
