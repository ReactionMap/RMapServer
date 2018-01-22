baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				configuration: 'MongoTalk'
					with: [ spec
						versionString: #stable;
						repository: 'github://pharo-nosql/mongotalk/mc' ];
				configuration: 'Teapot'
					with: [ spec
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main/' ];
				package: 'ReactionMapServer' with: [ spec requires: #('MongoTalk' 'Teapot') ];
				group: 'default' with: #('ReactionMapServer');
				yourself ]