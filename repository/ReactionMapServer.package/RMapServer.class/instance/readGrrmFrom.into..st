private
readGrrmFrom: aString into: aDictionary
	| grrm |
	grrm := aString lines readStream.
	self readCommandlineFrom: grrm into: aDictionary.
	self readAtomsFrom: grrm into: aDictionary.
	self readParamsFrom: grrm into: aDictionary