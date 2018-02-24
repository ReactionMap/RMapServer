sole instance
current
	^ Current ifNil: [ Current := (Smalltalk at: ServerClassName) new ]