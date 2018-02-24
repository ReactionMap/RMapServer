private-mongo
removeExtrasAll: anArrayOfOID
	self
		mongoExtras:
			[ :collection | anArrayOfOID do: [ :oid | collection delete: {('_id' -> oid)} asDictionary ] ]