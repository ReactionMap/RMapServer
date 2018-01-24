private-mongo
mongo: aBlock
	self ensureMongo.
	^ aBlock value: collection