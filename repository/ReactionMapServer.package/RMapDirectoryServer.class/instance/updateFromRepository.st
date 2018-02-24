repository
updateFromRepository
	| changed |
	changed := false.
	self repositoryPath
		in: [ :repo | 
			repo isDirectory
				ifFalse: [ repo createDirectory ].
			(repo filesMatching: '*.rmap')
				do: [ :rmapRef | 
					| name |
					name := rmapRef basenameWithoutExtension: 'rmap'.
					((self rmaps includesKey: name)
						and: [ rmapRef modificationTime < (self rmaps at: name) second ])
						ifFalse: [ | json rmap |
							json := (NeoJSONReader on: rmapRef readStream) next.
							rmap := Dictionary new
								at: '_id' put: name;
								at: 'grrm' put: (json at: 'grrm');
								at: 'meta' put: (self createMetaNamed: name from: json);
								yourself.
							self rmaps
								at: name
								put:
									{rmap.
									DateAndTime now}.
							changed := true ] ].
			self rmaps keys asArray
				do: [ :name | 
					(repo / (name , '.rmap')) isFile
						ifFalse: [ self rmaps removeKey: name ifAbsent: [  ].
							changed := true ] ] ].
	^ changed