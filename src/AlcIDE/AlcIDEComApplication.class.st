Class {
	#name : #AlcIDEComApplication,
	#superclass : #Object,
	#instVars : [
		'participant',
		'domain',
		'started',
		'providers'
	],
	#category : #AlcIDE
}

{ #category : #initialization }
AlcIDEComApplication >> initialize [
	started := false.
	providers := Dictionary new 
]

{ #category : #'as yet unclassified' }
AlcIDEComApplication >> modelTopic: aModelName [
	^ domain
		findOrRegisterTopicByName:
			('{1}/models/{2}'
				format:
					{participant name asString.
					aModelName})
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

{ #category : #'as yet unclassified' }
AlcIDEComApplication >> updateService: aModelName [
	^ domain
		findOrRegisterServiceByName:
			('{1}/models/update'
				format:
					{participant name asString.
					aModelName})
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
