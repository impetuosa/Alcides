Class {
	#name : #AlcIDEComApplication,
	#superclass : #Object,
	#instVars : [
		'participant',
		'domain',
		'started',
		'providers'
	],
	#classInstVars : [
		'instance'
	],
	#category : #AlcIDE
}

{ #category : #'as yet unclassified' }
AlcIDEComApplication class >> consumeNorthwind [
	^ self instance newModelConsumerNodeFor: 'norwind'
]

{ #category : #accessing }
AlcIDEComApplication class >> instance [
	^ instance
		ifNil: [ instance := AlcIDEComApplication new.
			instance
				startWith: OSPlatform current name , '-norwind'
				myIp: self ip
				masterHttpUrl: self masterUrl.
			instance ]
]

{ #category : #accessing }
AlcIDEComApplication class >> ip [
	^ OSPlatform current resolveIp
		ifNil: [ self error: 'impossible to obtain ip' ]
]

{ #category : #accessing }
AlcIDEComApplication class >> masterUrl [

	^ 'http://192.168.1.25:11311'
]

{ #category : #'as yet unclassified' }
AlcIDEComApplication class >> northwindModel [
	^ self consumeNorthwind model
]

{ #category : #'as yet unclassified' }
AlcIDEComApplication class >> provideNorthwind [
	| provider |
	
	provider := self instance newModelProviderNodeFor: 'norwind'.
	provider provide
]

{ #category : #accessing }
AlcIDEComApplication class >> stopAll [ 
	instance ifNotNil: [  instance stopAll  ].
	instance := nil.
]

{ #category : #'as yet unclassified' }
AlcIDEComApplication class >> worldMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Distributed Moose')
		order: 20;
		target: self;
		help: 'Jenkins CI Trigger'.
	(aBuilder item: #'Share Norwind')
		parent: #'Distributed Moose';
		action: [ self provideNorthwind ];
		order: 0;
		help: 'provide a model through a simple dds network';
		icon: (self iconNamed: #up).
	(aBuilder item: #'Load Norwind')
		parent: #'Distributed Moose';
		action: [ self consumeNorthwind ];
		order: 0;
		help: 'System browser to browse and edit code.';
		icon: (self iconNamed: #bottom).
	(aBuilder item: #'Request Norwind Update')
		parent: #'Distributed Moose';
		action: [ self consumeNorthwind requestNewVersion ];
		order: 0;
		help: 'System browser to browse and edit code.';
		icon: (self iconNamed: #refresh).
	(aBuilder item: #'Stop all')
		parent: #'Distributed Moose';
		action: [ self stopAll ];
		order: 0;
		help: 'System browser to browse and edit code.';
		icon: (self iconNamed: #stop)
]

{ #category : #initialization }
AlcIDEComApplication >> initialize [
	started := false.
	providers := Dictionary new 
]

{ #category : #'as yet unclassified' }
AlcIDEComApplication >> modelTopic: aModelName [

	^ domain
		  findOrRegisterTopicByName: ('/models/{1}' format: { aModelName })
		  type: 'Alce/VersionedModel'
]

{ #category : #initialization }
AlcIDEComApplication >> newModelConsumerNodeFor: aModelName [

	| modelTopic updateService consumer |
	^ providers at: aModelName ifAbsentPut: [ 
		  modelTopic := self modelTopic: aModelName.
		  updateService := self updateService: aModelName.
		  consumer := AlcIDEModelConsumer new
			              modelName: aModelName;
			              yourself.
		  consumer updateServiceCaller:
			  (updateService callerFor: participant).
		  consumer updateModelSubscription: (modelTopic subscriber
				   forParticipant: participant
				   onRead:
				   (MessageSend receiver: consumer selector: #updateModel:)
				   onFailure: (MessageSend receiver: self selector: #manageError:)) ]
]

{ #category : #initialization }
AlcIDEComApplication >> newModelProviderNodeFor: aModelName [

	| modelTopic updateService provider |
	^ providers at: aModelName ifAbsentPut: [ 
		  modelTopic := self modelTopic: aModelName.
		  updateService := self updateService: aModelName.
		  provider := AlcIDEModelProvider new
			              publication:
				              ((modelTopic publisher publishing: participant)
					               setLatched: true;
					               yourself);
			              modelName: aModelName;
			              yourself.
		  updateService
			  serve:
			  (MessageSend
				   receiver: provider
				   selector: #updateRequest:response:)
			  for: participant.
		  provider ]
]

{ #category : #initialization }
AlcIDEComApplication >> serviceUpdateType [
	^ DDSServiceTypeDefinition
		named: 'Alce/UpdateService'
		request:
			{(MDDSFieldDefinition
				name: #name
				type: (MDDSBasicTypeDefinition for: MDDSStringType new)).
			(MDDSFieldDefinition
				name: #version
				type: (MDDSBasicTypeDefinition for: MDDSInt16Type new))}
		response:
			{(MDDSFieldDefinition
				name: #errorText
				type: (MDDSBasicTypeDefinition for: MDDSStringType new)).
			(MDDSFieldDefinition
				name: #nextVersion
				type: (MDDSBasicTypeDefinition for: MDDSInt16Type new))}
]

{ #category : #initialization }
AlcIDEComApplication >> startWith: aName myIp: aStringWithIp masterHttpUrl: anUrl [
	aName isEmptyOrNil
		ifTrue: [ ^ self error: 'Name is compulsory!' ].
	started
		ifTrue: [ ^ self error: 'Application already started' ].
	domain := DDSExternallyDefinedDomain onSimpleDDS: anUrl.	" Add the protocol support "
	domain
		addProtocol: (DDSTCPProtocol encoding: MDDSEncoder decoding: MDDSDecoder).
	participant := DDSDomainParticipant
		domain: domain
		name: aName
		ip: aStringWithIp.
	" Register the type definition needed for the comunication "
	domain registerTypeDefinition: self versionedModelType.
	domain registerTypeDefinition: self serviceUpdateType.
	started := true
]

{ #category : #initialization }
AlcIDEComApplication >> stopAll [ 
	domain destroy. 
	domain := nil. 
	providers removeAll.
]

{ #category : #'as yet unclassified' }
AlcIDEComApplication >> updateService: aModelName [

	^ domain
		  findOrRegisterServiceByName:
		  ('/models/{1}/update' format: { aModelName })
		  type: 'Alce/UpdateService'
]

{ #category : #initialization }
AlcIDEComApplication >> versionedModelType [
	^ MDDSTypeDefinition
		named: 'Alce/VersionedModel'
		defined:
			{(MDDSFieldDefinition
				name: #version
				type: (MDDSBasicTypeDefinition for: MDDSInt16Type new)).
			(MDDSFieldDefinition
				name: #exportType
				type: (MDDSBasicTypeDefinition for: MDDSUInt8Type new)).
			(MDDSFieldDefinition
				name: #modelName
				type: (MDDSBasicTypeDefinition for: MDDSStringType new)).
			(MDDSFieldDefinition
				name: #model
				type: (MDDSBasicTypeDefinition for: MDDSStringType new))}
]
