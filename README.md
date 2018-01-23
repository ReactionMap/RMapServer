# RMapServer
ReactionMap server on Pharo Smalltalk

## Installation

1. RMapServer uses mongo db as its backend. Please set it up first.

2. Please evaluate the following on Pharo 6.1 (64bit VM) available at [pharo.org](https://pharo.org/download).

```
Metacello new
    repository: 'github://ReactionMap/RMapServer/repository/';
    baseline: 'RMapServer';
    load
```
