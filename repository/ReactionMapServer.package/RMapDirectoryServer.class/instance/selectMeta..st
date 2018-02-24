repository
selectMeta: aDictionary
	^ Array
		streamContents: [ :result | 
			self rmaps
				valuesDo: [ :pair | 
					pair first
						in: [ :meta | 
							(self jsonMatch: aDictionary to: meta)
								ifTrue: [ result nextPut: meta ] ] ] ]