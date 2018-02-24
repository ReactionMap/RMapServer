private-mongo
ensureMongo
	mongo isNil
		ifTrue: [ mongo := Mongo local ].
	mongo isAvailable
		ifFalse: [ [ mongo open ]
				on: ConnectionTimedOut
				do: [ :ex | 
					UIManager default alert: 'Can not connect to the local mongo server.'.
					Smalltalk exitFailure ].
			db := collection := extra := nil ].
	db ifNil: [ db := mongo databaseNamed: 'rmap' ].
	collection ifNil: [ collection := db getCollection: 'rmapCollection' ].
	extra ifNil: [ extra := db getCollection: 'rmapExtraCollection' ]