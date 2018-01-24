initialization
initializeTeapot
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