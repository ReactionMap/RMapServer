accessing
repositoryPath
	^ RepositoryPath ifNil: [ self defaultRepositoryPath ]