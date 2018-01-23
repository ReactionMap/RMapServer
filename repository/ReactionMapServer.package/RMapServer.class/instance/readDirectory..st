mongo
readDirectory: aFileReference
	aFileReference isDirectory
		ifFalse: [ ^ self ].
	aFileReference allFiles
		do: [ :file | 
			file extension = 'rmap'
				ifTrue: [self readFile: file] ]