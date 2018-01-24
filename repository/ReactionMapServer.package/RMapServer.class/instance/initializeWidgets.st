initialization
initializeWidgets
	portLabel := self newLabel
		label: 'port';
		yourself.
	portField := self newTextInput
		text: (teapot ifNil: [ self defaultPort ] ifNotNil: [ teapot server port ]) printString;
		removeEntryCompletion;
		ghostText: 'port #';
		acceptBlock: [ :string | string allSatisfy: #isDigit ];
		autoAccept: true;
		yourself.
	startStopButton := self newButton
		label: '';
		help: 'toggle start/stop the RMapServer';
		action: [ self toggleStartStopServer ];
		yourself.
	rmapList := self newList
		multiSelection: true;
		displayBlock: [ :rmap | (rmap at: 'meta') at: 'name' ];
		menu: [ :menu :shifted | self rmapListMenu: menu shifted: shifted ];
		yourself.
	self updateRMapList