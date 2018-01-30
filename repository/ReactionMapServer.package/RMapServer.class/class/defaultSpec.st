specs
defaultSpec
	<spec>
	^ SpecLayout composed
		newColumn: [ :c | 
			c
				newRow: [ :r | 
					r
						add: #portLabel width: 50;
						add: #portField;
						add: #startStopButton width: 80;
						yourself ]
					height: 25;
				newRow: [ :r | 
					r
						add: #rmapList;
						yourself ] ];
		yourself