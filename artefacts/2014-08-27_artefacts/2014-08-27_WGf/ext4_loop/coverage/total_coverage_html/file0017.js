var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 52</i>';
states['fold000001'] = false;
texts['fold000054'] = '<a href="javascript:fold(\'fold000054\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 54 to line 57</i>';
states['fold000054'] = false;
texts['fold000061'] = '<a href="javascript:fold(\'fold000061\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 61 to line 62</i>';
states['fold000061'] = false;
texts['fold000064'] = '<a href="javascript:fold(\'fold000064\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 64 to line 75</i>';
states['fold000064'] = false;
texts['fold000079'] = '<a href="javascript:fold(\'fold000079\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 79 to line 80</i>';
states['fold000079'] = false;
texts['fold000084'] = '<a href="javascript:fold(\'fold000084\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 84 to line 98</i>';
states['fold000084'] = false;
texts['fold000101'] = '<a href="javascript:fold(\'fold000101\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 101 to line 103</i>';
states['fold000101'] = false;
texts['fold000105'] = '<a href="javascript:fold(\'fold000105\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 105 to line 106</i>';
states['fold000105'] = false;
texts['fold000108'] = '<a href="javascript:fold(\'fold000108\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 108 to line 113</i>';
states['fold000108'] = false;
texts['fold000115'] = '<a href="javascript:fold(\'fold000115\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 115 to line 116</i>';
states['fold000115'] = false;
texts['fold000118'] = '<a href="javascript:fold(\'fold000118\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 118 to line 123</i>';
states['fold000118'] = false;
texts['fold000125'] = '<a href="javascript:fold(\'fold000125\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 125 to line 131</i>';
states['fold000125'] = false;

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
