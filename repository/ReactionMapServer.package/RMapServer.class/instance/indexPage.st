teapot-html
indexPage
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