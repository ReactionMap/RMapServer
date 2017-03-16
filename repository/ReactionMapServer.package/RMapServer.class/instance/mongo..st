mongo
mongo: aBlock
	| db collection |
	mongo isNil
		ifTrue: [ mongo := Mongo local ].
	mongo isAvailable not
		ifTrue: [ mongo open ].
	db := mongo databaseNamed: 'rmap'.
	collection := db getCollection: 'rmapCollection'.
	^ aBlock value: collection