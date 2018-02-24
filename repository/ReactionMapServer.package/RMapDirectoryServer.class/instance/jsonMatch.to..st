repository
jsonMatch: aDictionary1 to: aDictionary2
	aDictionary1
		keysAndValuesDo: [ :keys :value | 
			| current |
			current := aDictionary2.
			(keys substrings: '.') do: [ :key | current := current at: key ifAbsent: [ ^ false ] ].
			current = value
				ifFalse: [ ^ false ] ].
	^ true