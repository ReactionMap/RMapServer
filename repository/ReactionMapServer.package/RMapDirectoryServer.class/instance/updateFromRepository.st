repository
updateFromRepository
	self repositoryPath
		in: [ :repo | 
			repo isDirectory
				ifFalse: [ repo createDirectory ].
			(repo filesMatching: '*.rmap')
				do: [ :rmapRef | 
					| name |
					name := rmapRef basenameWithoutExtension: 'rmap'.
					((self rmaps includesKey: name)
						and: [ rmapRef modificationTime < (self rmaps at: name) second ]) not
						ifTrue: [ | json rmap |
							json := (NeoJSONReader on: rmapRef readStream) next.
							rmap := Dictionary new.
							rmap at: '_id' put: name.
							rmap at: 'grrm' put: (json at: 'grrm').
							rmap at: 'meta' put: (self createMetaNamed: name from: json).
							self rmaps
								at: name
								put:
									{rmap.
									DateAndTime now} ] ] ]