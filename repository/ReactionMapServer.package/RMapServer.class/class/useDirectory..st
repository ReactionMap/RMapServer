services
useDirectory: aString
	ServerClassName := #RMapDirectoryServer.
	RMapDirectoryServer repositoryPath: aString.
	self flushCurrent