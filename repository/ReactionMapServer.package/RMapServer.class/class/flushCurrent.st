accessing
flushCurrent
	Current
		ifNotNil: [ 
			| current |
			current := Current.
			Current := nil.
			current stop ]