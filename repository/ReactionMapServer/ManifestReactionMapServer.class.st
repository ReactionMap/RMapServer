"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestReactionMapServer,
	#superclass : #PackageManifest,
	#category : #'ReactionMapServer-Manifest'
}

{ #category : #'code-critics' }
ManifestReactionMapServer class >> ruleGRUsesCurlyBraceArraysRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#ReactionMapServer)) #'2019-04-28T08:44:11.106689+09:00') )
]

{ #category : #'code-critics' }
ManifestReactionMapServer class >> ruleRBStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#RMapDirectoryServer #updateFromRepository #false)) #'2019-04-28T08:59:21.728974+09:00') )
]
