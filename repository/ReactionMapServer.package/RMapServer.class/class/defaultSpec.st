specs
defaultSpec
	<spec>
	^ SpecLayout composed
		newColumn: [ :c | 
			c
				newRow: [ :r | 
					r
						add: #portLabel;
						add: #portField;
						add: #startStopButton;
						yourself ];
				newRow: [ :r | 
					r
						add: #rmapList;
						yourself ] ];
		yourself