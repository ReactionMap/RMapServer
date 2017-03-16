private
selectExtrasAll: anArrayOfOID
	^ Array
		new: anArrayOfOID size * 100
		streamContents: [ :stream | 
			self
				mongoExtras: [ :collection | anArrayOfOID do: [ :oid | stream nextPutAll: ((collection detect: {('_id' -> oid)} asDictionary) at: 'contents') ] ] ]