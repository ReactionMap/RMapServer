mongo
readFile: aFileReference
	aFileReference isFile
		ifFalse: [ ^ self ].
	aFileReference extension ~= 'rmap'
		ifTrue: [ ^ self ].
	aFileReference
		readStreamDo: [ :readStream | 
			self
				add: (NeoJSONReader on: readStream) next
				named: aFileReference basenameWithoutExtension
				ifFailed: [ :msg | self error: msg ] ]