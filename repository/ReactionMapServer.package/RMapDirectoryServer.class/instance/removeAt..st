repository
removeAt: id
	self repositoryPath / (id , '.rmap')
		in: [ :ref | 
			ref isFile
				ifTrue: [ ref delete ] ].
	self rmaps removeKey: id ifAbsent: [  ]