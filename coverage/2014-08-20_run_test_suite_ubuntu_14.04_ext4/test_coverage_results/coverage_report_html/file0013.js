var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 93</i>';
states['fold000001'] = false;
texts['fold000095'] = '<a href="javascript:fold(\'fold000095\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 95 to line 95</i>';
states['fold000095'] = false;
texts['fold000098'] = '<a href="javascript:fold(\'fold000098\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 98 to line 115</i>';
states['fold000098'] = false;
texts['fold000118'] = '<a href="javascript:fold(\'fold000118\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 118 to line 153</i>';
states['fold000118'] = false;
texts['fold000156'] = '<a href="javascript:fold(\'fold000156\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 156 to line 169</i>';
states['fold000156'] = false;
texts['fold000172'] = '<a href="javascript:fold(\'fold000172\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 172 to line 186</i>';
states['fold000172'] = false;
texts['fold000188'] = '<a href="javascript:fold(\'fold000188\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 188 to line 192</i>';
states['fold000188'] = false;
texts['fold000194'] = '<a href="javascript:fold(\'fold000194\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 194 to line 208</i>';
states['fold000194'] = false;

function fold(id) {
  tmp = document.getElementById(id).innerHTML;
  document.getElementById(id).innerHTML = texts[id];
  texts[id] = tmp;
  states[id] = !(states[id]);
}

function unfoldAll() {
  for (key in states) {
    if (states[key]) {
      fold(key);
    }
  }
}

function foldAll() {
  for (key in states) {
    if (!(states[key])) {
      fold(key);
    }
  }
}
