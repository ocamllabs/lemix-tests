var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 81</i>';
states['fold000001'] = false;
texts['fold000083'] = '<a href="javascript:fold(\'fold000083\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 83 to line 94</i>';
states['fold000083'] = false;
texts['fold000096'] = '<a href="javascript:fold(\'fold000096\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 96 to line 97</i>';
states['fold000096'] = false;
texts['fold000099'] = '<a href="javascript:fold(\'fold000099\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 99 to line 101</i>';
states['fold000099'] = false;
texts['fold000105'] = '<a href="javascript:fold(\'fold000105\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 105 to line 114</i>';
states['fold000105'] = false;
texts['fold000116'] = '<a href="javascript:fold(\'fold000116\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 116 to line 121</i>';
states['fold000116'] = false;
texts['fold000123'] = '<a href="javascript:fold(\'fold000123\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 123 to line 124</i>';
states['fold000123'] = false;
texts['fold000129'] = '<a href="javascript:fold(\'fold000129\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 129 to line 200</i>';
states['fold000129'] = false;

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
