Class {
	#name : #AlceProjectTree,
	#superclass : #AlceTreeWidget,
	#category : #'AlcIDE-MidasWidgets'
}

{ #category : #specs }
AlceProjectTree class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #alceProjectBrowser)
		parent: self alceBrowsers;
		label: (self title); 
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
AlceProjectTree class >> runMe [
	<script>
^ super runMe
]

{ #category : #specs }
AlceProjectTree class >> title [

	^ 'Project Tree Browser'
]

{ #category : #visiting }
AlceProjectTree >> canFollowEntity: aModel [

	^ (aModel isKindOf: AlcixModel) or: [ 
		  (aModel isKindOf: AlcixReference) or: [ 
			  aModel isKindOf: AlcixUserType ] ]
]

{ #category : #visiting }
AlceProjectTree >> childrenFor: anEntry [

	| children |
	children := OrderedCollection new.
	(anEntry isKindOf: AlcixReference)
		ifTrue: [ 
			children addAll:
				(anEntry types groupedBy: [ :t | t class entryName ]) associations ]
		ifFalse: [ 
			(anEntry isKindOf: AlcixContainer) ifTrue: [ 
				children addAll: (anEntry types sort: #name ascending) ] ].
	anEntry isAssociation ifTrue: [ 
		children addAll: (anEntry value sort: #name ascending) ].
	^ children removeDuplicates
]

{ #category : #visiting }
AlceProjectTree >> followAction [

	(toSelect isKindOf: AlcixModel)
		ifTrue: [ 
			tree items:
				(toSelect references sort: #className ascending , #name ascending) ]
		ifFalse: [ self selectEntityPath: toSelect ]
]

{ #category : #actions }
AlceProjectTree >> freezeDuring: aFullBlockClosure [ 
	aFullBlockClosure value
]

{ #category : #visiting }
AlceProjectTree >> selectEntityPath: anObject [ 
	anObject accept: self 
]

{ #category : #visiting }
AlceProjectTree >> selection: aSelection [
super selection: aSelection
]

{ #category : #visiting }
AlceProjectTree >> visitAccessModule: anAlcixAccessModule [ 
	self visitLibrary: anAlcixAccessModule 
]

{ #category : #visiting }
AlceProjectTree >> visitClass: aForm [ 
	self visitModule: aForm
]

{ #category : #visiting }
AlceProjectTree >> visitForm: aForm [ 
	self visitModule: aForm
]

{ #category : #visiting }
AlceProjectTree >> visitLibrary: anAlcixLibrary [

	tree selectedItem = anAlcixLibrary ifFalse: [ 
		tree
			selectPath: { (tree roots indexOf: anAlcixLibrary) }
			scrollToSelection: true ]
]

{ #category : #visiting }
AlceProjectTree >> visitModule: anAlcixModule [

	| kinds kind containerIndex kindIndex modIindex |
	tree selectedItem = anAlcixModule ifFalse: [ 
	containerIndex := tree roots indexOf: anAlcixModule container.
	kinds := tree childrenFor: anAlcixModule container.
	kind := kinds detect: [ :a | 
		        anAlcixModule className includesSubstring: a key ].
	kindIndex := kinds indexOf: kind.
	modIindex := kind value indexOf: anAlcixModule.

	
		tree
			selectPath: { 
					containerIndex.
					kindIndex.
					modIindex }
			scrollToSelection: true ]
]

{ #category : #visiting }
AlceProjectTree >> visitQuery: aForm [ 
	self visitModule: aForm
]

{ #category : #visiting }
AlceProjectTree >> visitReport: aForm [ 
	self visitModule: aForm
]

{ #category : #visiting }
AlceProjectTree >> visitTable: aForm [ 
	self visitModule: aForm
]

{ #category : #visiting }
AlceProjectTree >> visitUserType: anAlcixUserType [ 
	anAlcixUserType container accept: self 
]
