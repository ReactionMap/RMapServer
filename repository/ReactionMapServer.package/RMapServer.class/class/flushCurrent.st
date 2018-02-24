sole instance
flushCurrent
	<script: 'self flushCurrent'>
	Current
		ifNotNil: [ | current |
			current := Current.
			Current := nil.
			current
				stop;
				delete ]