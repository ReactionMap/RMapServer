Class {
	#name : #RMapServer,
	#superclass : #ComposableModel,
	#instVars : [
		'teapot',
		'random',
		'portLabel',
		'portField',
		'startStopButton',
		'rmapList'
	],
	#classVars : [
		'Current',
		'ServerClassName'
	],
	#category : 'ReactionMapServer'
}

{ #category : #'sole instance' }
RMapServer class >> current [
	^ Current ifNil: [ Current := (Smalltalk at: ServerClassName) new ]
]

{ #category : #specs }
RMapServer class >> defaultSpec [
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
]

{ #category : #'sole instance' }
RMapServer class >> flushCurrent [
	<script: 'self flushCurrent'>
	Current
		ifNotNil: [ | current |
			current := Current.
			Current := nil.
			current
				stop;
				delete ]
]

{ #category : #'class initialization' }
RMapServer class >> initialize [
	SessionManager default registerToolClassNamed: self name.
	ServerClassName := #RMapDirectoryServer
]

{ #category : #services }
RMapServer class >> open [
	<script: 'RMapServer open'>
	^ self current openWithSpec
		title: 'RMapServer' translated;
		yourself
]

{ #category : #snapshotting }
RMapServer class >> shutDown [
	self flushCurrent
]

{ #category : #services }
RMapServer class >> start [
	self current start
]

{ #category : #snapshotting }
RMapServer class >> startUp [
	self
		flushCurrent.
	Smalltalk isInteractive
		ifTrue: [ self open ]
]

{ #category : #services }
RMapServer class >> stop [
	self current stop
]

{ #category : #services }
RMapServer class >> useDirectory [
	self useDirectory: nil
]

{ #category : #services }
RMapServer class >> useDirectory: aString [
	ServerClassName := #RMapDirectoryServer.
	RMapDirectoryServer repositoryPath: aString.
	self flushCurrent
]

{ #category : #services }
RMapServer class >> useMongo [
	ServerClassName := #RMapMongoServer.
	self flushCurrent
]

{ #category : #repository }
RMapServer >> at: id [
	^ self subclassResponsibility
]

{ #category : #private }
RMapServer >> createMetaNamed: aString from: aDictionary [
	| meta |
	meta := Dictionary new.
	meta at: 'name' put: aString.
	self readGrrmFrom: (aDictionary at: 'grrm') into: meta.
	meta at: 'numEQ' put: ((aDictionary at: 'vertices') select: [ :v | (v at: 'label') first = $E ]) size.
	meta at: 'numTS' put: ((aDictionary at: 'vertices') select: [ :v | (v at: 'label') first = $T ]) size.
	meta at: 'numDC' put: ((aDictionary at: 'vertices') select: [ :v | (v at: 'label') first = $D ]) size.
	meta at: 'stableEQs' put: (self stableEQs: 10 from: (aDictionary at: 'vertices')).
	^ meta
]

{ #category : #defaults }
RMapServer >> defaultPort [
	^ 1701
]

{ #category : #'teapot-api' }
RMapServer >> get: aDictionary [
	^ self at: (aDictionary at: '_id' ifAbsent: [ 0 ]) asInteger
]

{ #category : #'ui operations' }
RMapServer >> importRMapDirectory [
	(UIManager default
		chooseDirectory: 'Choose an RMap file to import'
		from: FileLocator home)
		ifNotNil: [ :directory | 
			| files |
			files := directory allFiles select: [ :file | file extension = 'rmap' ].
			files
				ifEmpty: [ ^ UIManager notify: 'No RMap file in the directory: ' , directory fullName ].
			(ProgressBarMorph from: 0 to: files size)
				in: [ :progress | 
					progress
						position: ActiveHand position - (progress width // 2);
						openInWorld.
					files
						do: [ :file | 
							self readFile: file.
							progress increment.
							Processor yield ].
					progress delete ].
			self updateRMapList ]
]

{ #category : #'ui operations' }
RMapServer >> importRMapFile [
	(Smalltalk ui theme
		chooseFullFileNameIn: UIManager default modalMorph
		title: 'Choose an RMap file to import'
		patterns: #('*.rmap')
		path: FileLocator home
		preview: true)
		ifNotNil: [ :fileReference | 
			self readFile: fileReference asFileReference.
			self updateRMapList ]
]

{ #category : #'teapot-html' }
RMapServer >> indexPage [
	^ '<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<link href="https://fonts.googleapis.com/css?family=Lora|Libre+Franklin|Source+Code+Pro" rel="stylesheet">
</head>
<body style="font-family: ''Libre Franklin'', sans-serif; font-size:12pt;">
<div id="title" style="font-family: ''Lora'', serif; font-size:36pt; padding-bottom:20px;">Reaction Map Server</div>
<div id="query" style="width:90%">
name	<input type="text" id="name" size=30><br>
 command <input type="text" id="command1" size=10>
 method <input type="text" id="command2" size=10>
 basis <input type="text" id="command3" size=10><br>
	C	<input type="text" id="atoms.C" size=3>
	H	<input type="text" id="atoms.H" size=3>
	O	<input type="text" id="atoms.O" size=3>
	<input type="text" id="atom1.element" title="element" size=2 style="margin-left:10px;"><input type="text" id="atom1.qt" title="quantity" size=3>
	<input type="text" id="atom2.element" title="element" size=2 style="margin-left:10px;"><input type="text" id="atom2.qt" title="quantity" size=3>
	<input type="text" id="atom3.element" title="element" size=2 style="margin-left:10px;"><input type="text" id="atom3.qt" title="quantity" size=3>
	<br>
</div>
<div style="width:30%; float:left; margin-right: 20px;">
<div id="search" style="text-align:center; cursor:pointer; border:solid 1px gray; border-radius: 5px; font-size:small; color:black; text-decoration:none; padding:4px;margin-top:10px;margin-bottom:5px;" onClick="RMap.query()">Search</div>
<div id="listbox" style="height:300px; border:solid 1px #101010; overflow:scroll; padding: 0px;">
<ul id="list" style="list-style-type:none;padding:10px; margin:0px;">
</ul>
</div>
<a id="download" style="font-size:small; color:black; text-decoration:none;" href="/"><div id="downloadbox" style="text-align:center; cursor:pointer; border:solid 1px gray; border-radius: 5px; visibility:hidden; padding:4px; margin-top:5px;">Download</div></a>
</div>
<div id="detail" style="font-family: ''Source Code Pro'', monospace; width: 60%; height:300px; margin-top: 20px; overflow: scroll; float:both;">
</div>
<script type="text/javascript">
RMap = {};
RMap.dom = {};
RMap.dom.search = document.getElementById("search");
RMap.dom.name = document.getElementById("name");
RMap.dom.command1 = document.getElementById("command1");
RMap.dom.command2 = document.getElementById("command2");
RMap.dom.command3 = document.getElementById("command3");
RMap.dom.C = document.getElementById("atoms.C");
RMap.dom.H = document.getElementById("atoms.H");
RMap.dom.O = document.getElementById("atoms.O");
RMap.dom.atom1 = {element: document.getElementById("atom1.element"), qt: document.getElementById("atom1.qt")};
RMap.dom.atom2 = {element: document.getElementById("atom2.element"), qt: document.getElementById("atom2.qt")};
RMap.dom.atom3 = {element: document.getElementById("atom3.element"), qt: document.getElementById("atom3.qt")};
RMap.dom.listbox = document.getElementById("listbox");
RMap.dom.list = document.getElementById("list");
RMap.dom.detail = document.getElementById("detail");
RMap.dom.download = document.getElementById("download");
RMap.dom.downloadbox = document.getElementById("downloadbox");
RMap.rmaps = [];
RMap.index = null;
RMap.query = function () {
	var query = [];
	if (RMap.dom.name.value)
		query.push("name="+encodeURIComponent(RMap.dom.name.value));
	if (RMap.dom.command1.value) 
		query.push("command1="+encodeURIComponent(RMap.dom.command1.value));
	if (RMap.dom.command2.value) 
		query.push("command2="+encodeURIComponent(RMap.dom.command2.value));
	if (RMap.dom.command3.value) 
		query.push("command3="+encodeURIComponent(RMap.dom.command3.value));
	if (parseInt(RMap.dom.C.value))
		query.push("atoms.C="+encodeURIComponent(parseInt(RMap.dom.C.value)));
	if (parseInt(RMap.dom.H.value))
		query.push("atoms.H="+encodeURIComponent(parseInt(RMap.dom.H.value)));
	if (parseInt(RMap.dom.O.value))
		query.push("atoms.O="+encodeURIComponent(parseInt(RMap.dom.O.value)));
	if (RMap.dom.atom1.element.value && parseInt(RMap.dom.atom1.qt.value))
		query.push("atoms."+encodeURIComponent(RMap.dom.atom1.element.value)+"="+parseInt(RMap.dom.atom1.qt.value));
	if (RMap.dom.atom2.element.value && parseInt(RMap.dom.atom2.qt.value))
		query.push("atoms."+encodeURIComponent(RMap.dom.atom2.element.value)+"="+parseInt(RMap.dom.atom2.qt.value));
	if (RMap.dom.atom3.element.value && parseInt(RMap.dom.atom3.qt.value))
		query.push("atoms."+encodeURIComponent(RMap.dom.atom3.element.value)+"="+parseInt(RMap.dom.atom3.qt.value));
	var req = new XMLHttpRequest();
	req.open("GET", "/api/search?"+query.join("&"));
	req.onload = function () {
 		if (req.readyState == 4) {
			if (req.status == 200) {
				RMap.index = null;
				RMap.rmaps = JSON.parse(req.responseText);
				RMap.update();
			}
		}
	};
	req.send();
}
RMap.update = function () { 
	var child = RMap.dom.list.firstChild;
	while (child) { 
		RMap.dom.list.removeChild(child);
		child = RMap.dom.list.firstChild;
	}
	for (var i = 0; i < RMap.rmaps.length; i++) {
		var item = document.createElement("li");
		var content = RMap.rmaps[i].meta.name;
		item.style.cursor = "pointer";
		item.innerText = content;
		item.textContent = content;
		item.index = i;
		item.onclick = function(event) {
			var index = event.target.index;
			RMap.index = index;
			RMap.show();
		};
		RMap.dom.list.appendChild(item);
	}
	RMap.dom.downloadbox.style.visibility="hidden";
	RMap.dom.download.href="/";
	RMap.show();
};
RMap.show = function() { 
	var content = "";
	if (RMap.index != null) { 
		content = RMap.rmaps[RMap.index].grrm.replace(/&/g, "&amp").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\r?\n/g, "<br>");
		RMap.dom.download.href="/api/download/"+encodeURIComponent(RMap.rmaps[RMap.index].meta.name)+"?_id="+RMap.rmaps[RMap.index]._id;
		RMap.dom.downloadbox.style.visibility="visible";
	}
	RMap.dom.detail.innerHTML = content;
	var item = RMap.dom.list.firstChild;
	for (var i = 0; item ; i++) { 
		if (i == RMap.index) { 
			item.style.backgroundColor = "gray";
			item.style.color = "white";
		} else { 
			item.style.backgroundColor = "white";
			item.style.color = "black";
		}
		item = item.nextSibling;
	}
};
</script>
</body></body>' copyReplaceAll: String cr with: String crlf
]

{ #category : #initialization }
RMapServer >> initialize [
	super initialize.
	random := Random new.
	self updateRMapList.
	self initializeTeapot
]

{ #category : #initialization }
RMapServer >> initializeTeapot [
	<script: 'self current stop; initializeTeapot; start'>
	teapot ifNotNil: #stop.
	teapot := Teapot on
		GET: '/' -> [ :req | self indexPage ];
		GET:
			'/scripts/<name>'
				-> [ :req | (FileSystem workingDirectory / 'scripts' / (req at: 'name')) readStream ];
		GET: '/api/search' -> [ :req | self search: (self query: req) ];
		output: #json;
		GET: '/api/get' -> [ :req | self get: (self query: req) ];
		output: #json;
		GET:
			'/api/download/<name>'
				-> [ :req | (NeoJSONWriter toString: (self get: (self query: req))) readStream ];
		output: #stream;
		yourself.
	startStopButton label: self startStopButtonLabel
]

{ #category : #initialization }
RMapServer >> initializeWidgets [
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
]

{ #category : #teapot }
RMapServer >> isRunning [
	^ teapot server isRunning
]

{ #category : #teapot }
RMapServer >> port [
	^ teapot server port
]

{ #category : #accessing }
RMapServer >> portField [
	^ portField
]

{ #category : #accessing }
RMapServer >> portField: anObject [
	portField := anObject
]

{ #category : #accessing }
RMapServer >> portLabel [
	^ portLabel
]

{ #category : #accessing }
RMapServer >> portLabel: anObject [
	portLabel := anObject
]

{ #category : #'private-teapot' }
RMapServer >> query: aTeaRequest [
	| url query |
	url := aTeaRequest url.
	query := Dictionary new.
	(url hasQuery
		ifTrue: [ url query asDictionary ]
		ifFalse: [ 
			(aTeaRequest entity isKindOf: ZnApplicationFormUrlEncodedEntity)
				ifTrue: [ aTeaRequest entity asDictionary ]
				ifFalse: [ Dictionary new ] ])
		keysAndValuesDo: [ :key :value | 
			(key size > 6 and: [ (key copyFrom: 1 to: 6) = 'atoms.' ])
				ifTrue: [ query at: key put: value asInteger ]
				ifFalse: [ query at: key put: value ] ].
	^ query
]

{ #category : #private }
RMapServer >> readAtomsFrom: aStream into: aDictionary [
	| atoms |
	aStream next.
	aStream next.
	atoms := Dictionary new.
	[ aStream peek trim = 'OPTIONS' ]
		whileFalse: [ | element |
			element := (aStream next copyFrom: 1 to: 2) trim.
			atoms at: element put: (atoms at: element ifAbsent: [ 0 ]) + 1 ].
	aDictionary at: 'atoms' ifAbsentPut: [ atoms ]
]

{ #category : #private }
RMapServer >> readCommandlineFrom: aStream into: aDictionary [
	| commandline |
	commandline := aStream next substrings: '/'.
	commandline size >= 1
		ifTrue: [ aDictionary at: 'command1' ifAbsentPut: [ commandline first copyWithoutFirst trim ] ].
	commandline size >= 2
		ifTrue: [ aDictionary at: 'command2' ifAbsentPut: [ commandline second ] ].
	commandline size >= 3
		ifTrue: [ aDictionary at: 'command3' ifAbsentPut: [ commandline third ] ]
]

{ #category : #repository }
RMapServer >> readFile: aFileReference [
	^ self subclassResponsibility
]

{ #category : #private }
RMapServer >> readGrrmFrom: aString into: aDictionary [
	| grrm |
	grrm := aString lines readStream.
	self readCommandlineFrom: grrm into: aDictionary.
	self readAtomsFrom: grrm into: aDictionary.
	self readParamsFrom: grrm into: aDictionary
]

{ #category : #private }
RMapServer >> readParamsFrom: aStream into: aDictionary [
	aStream next.
	[ aStream atEnd ]
		whileFalse: [ | pair |
			pair := aStream next substrings: '='.
			pair size > 1
				ifTrue: [ aDictionary at: pair first ifAbsentPut: [ pair second ] ]
				ifFalse: [ aDictionary at: pair first put: true ] ]
]

{ #category : #repository }
RMapServer >> removeAt: id [
	^ self subclassResponsibility
]

{ #category : #'ui operations' }
RMapServer >> removeSelectedRMaps [
	(UIManager confirm: 'Do you really want to remove all the selected RMaps?')
		ifFalse: [ ^ self ].
	rmapList selectedItems do: [ :item | self removeAt: (item at: '_id') ].
	self updateRMapList
]

{ #category : #accessing }
RMapServer >> rmapList [
	^ rmapList
]

{ #category : #accessing }
RMapServer >> rmapList: anObject [
	rmapList := anObject
]

{ #category : #menus }
RMapServer >> rmapListMenu: aMenu shifted: aBoolean [
	aMenu
		add: 'Import a file...' target: self selector: #importRMapFile;
		add: 'Import all from a directory...' target: self selector: #importRMapDirectory.
	rmapList selectedIndexes
		ifNotEmpty: [ aMenu
				addLine;
				add: 'Remove selected rmaps' target: self selector: #removeSelectedRMaps ].
	^ aMenu
]

{ #category : #'teapot-api' }
RMapServer >> search: aDictionary [
	| query |
	query := Dictionary new.
	aDictionary
		keysAndValuesDo: [ :key :value | value asString trim ifNotEmpty: [ query at: 'meta.' , key put: value ] ].
	^ self selectMeta: query
]

{ #category : #repository }
RMapServer >> selectMeta: aDictionary [
	^ self subclassResponsibility
]

{ #category : #private }
RMapServer >> stableEQs: anInteger from: anArrayOfDictionary [
	| eqs |
	eqs := SortedCollection sortBlock: [ :less :more | (less at: 'energy') <= (more at: 'energy') ].
	anArrayOfDictionary
		do: [ :v | 
			((v at: 'label') first = $E and: [ eqs size < anInteger or: [ (v at: 'energy') <= (eqs last at: 'energy') ] ])
				ifTrue: [ eqs add: v.
					[ eqs size > anInteger ] whileTrue: [ eqs removeLast ] ] ].
	^ eqs asArray
]

{ #category : #teapot }
RMapServer >> start [
	teapot start.
	self startStopButton label: self startStopButtonLabel
]

{ #category : #accessing }
RMapServer >> startStopButton [
	^ startStopButton
]

{ #category : #accessing }
RMapServer >> startStopButton: anObject [
	startStopButton := anObject
]

{ #category : #accessing }
RMapServer >> startStopButtonLabel [
	^ self isRunning
		ifTrue: [ 'Running' ]
		ifFalse: [ 'Down' ]
]

{ #category : #teapot }
RMapServer >> stop [
	teapot stop.
	self startStopButton label: self startStopButtonLabel
]

{ #category : #'ui operations' }
RMapServer >> toggleStartStopServer [
	self isRunning
		ifTrue: [ self stop ]
		ifFalse: [ self start ]
]

{ #category : #private }
RMapServer >> updateRMapList [
	rmapList
		items: (self selectMeta: {} asDictionary);
		resetSelection
]
