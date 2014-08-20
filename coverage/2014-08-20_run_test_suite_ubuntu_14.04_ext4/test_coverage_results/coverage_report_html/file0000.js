var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 79</i>';
states['fold000001'] = false;
texts['fold000081'] = '<a href="javascript:fold(\'fold000081\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 81 to line 90</i>';
states['fold000081'] = false;
texts['fold000092'] = '<a href="javascript:fold(\'fold000092\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 92 to line 94</i>';
states['fold000092'] = false;
texts['fold000096'] = '<a href="javascript:fold(\'fold000096\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 96 to line 99</i>';
states['fold000096'] = false;
texts['fold000101'] = '<a href="javascript:fold(\'fold000101\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 101 to line 155</i>';
states['fold000101'] = false;
texts['fold000157'] = '<a href="javascript:fold(\'fold000157\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 157 to line 159</i>';
states['fold000157'] = false;
texts['fold000161'] = '<a href="javascript:fold(\'fold000161\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 161 to line 162</i>';
states['fold000161'] = false;
texts['fold000164'] = '<a href="javascript:fold(\'fold000164\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 164 to line 166</i>';
states['fold000164'] = false;
texts['fold000168'] = '<a href="javascript:fold(\'fold000168\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 168 to line 229</i>';
states['fold000168'] = false;
texts['fold000231'] = '<a href="javascript:fold(\'fold000231\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 231 to line 243</i>';
states['fold000231'] = false;
texts['fold000245'] = '<a href="javascript:fold(\'fold000245\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 245 to line 260</i>';
states['fold000245'] = false;

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
