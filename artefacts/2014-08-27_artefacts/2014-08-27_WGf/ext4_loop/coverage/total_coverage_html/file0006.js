var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 49</i>';
states['fold000001'] = false;
texts['fold000051'] = '<a href="javascript:fold(\'fold000051\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 51 to line 52</i>';
states['fold000051'] = false;
texts['fold000054'] = '<a href="javascript:fold(\'fold000054\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 54 to line 55</i>';
states['fold000054'] = false;
texts['fold000057'] = '<a href="javascript:fold(\'fold000057\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 57 to line 70</i>';
states['fold000057'] = false;
texts['fold000074'] = '<a href="javascript:fold(\'fold000074\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 74 to line 81</i>';
states['fold000074'] = false;
texts['fold000084'] = '<a href="javascript:fold(\'fold000084\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 84 to line 84</i>';
states['fold000084'] = false;
texts['fold000086'] = '<a href="javascript:fold(\'fold000086\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 86 to line 111</i>';
states['fold000086'] = false;

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
