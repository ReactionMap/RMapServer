repository
selectMeta: aDictionary
	^ (self
		mongo: [ :collection | 
			collection
				query: [ :query | 
					query
						where: aDictionary;
						fields:
								{('meta' -> 1).
									('grrm' -> 1)} asDictionary ] ])
		collect: [ :dict | 
			dict
				at: '_id' put: (dict at: '_id') value printString;
				yourself ]