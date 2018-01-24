private-mongo
mongoExtras: aBlock
	self ensureMongo.
	^ aBlock value: extra