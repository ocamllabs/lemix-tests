var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 14</i>';
states['fold000001'] = false;
texts['fold000017'] = '<a href="javascript:fold(\'fold000017\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 17 to line 22</i>';
states['fold000017'] = false;
texts['fold000028'] = '<a href="javascript:fold(\'fold000028\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 28 to line 34</i>';
states['fold000028'] = false;
texts['fold000039'] = '<a href="javascript:fold(\'fold000039\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 39 to line 41</i>';
states['fold000039'] = false;
texts['fold000046'] = '<a href="javascript:fold(\'fold000046\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 46 to line 46</i>';
states['fold000046'] = false;
texts['fold000055'] = '<a href="javascript:fold(\'fold000055\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 55 to line 55</i>';
states['fold000055'] = false;
texts['fold000058'] = '<a href="javascript:fold(\'fold000058\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 58 to line 62</i>';
states['fold000058'] = false;
texts['fold000065'] = '<a href="javascript:fold(\'fold000065\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 65 to line 67</i>';
states['fold000065'] = false;

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
