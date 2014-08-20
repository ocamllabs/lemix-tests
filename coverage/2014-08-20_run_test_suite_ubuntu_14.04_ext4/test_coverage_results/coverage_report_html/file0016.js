var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 9</i>';
states['fold000001'] = false;
texts['fold000014'] = '<a href="javascript:fold(\'fold000014\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 14 to line 14</i>';
states['fold000014'] = false;
texts['fold000016'] = '<a href="javascript:fold(\'fold000016\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 16 to line 16</i>';
states['fold000016'] = false;
texts['fold000018'] = '<a href="javascript:fold(\'fold000018\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 18 to line 21</i>';
states['fold000018'] = false;
texts['fold000023'] = '<a href="javascript:fold(\'fold000023\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 23 to line 23</i>';
states['fold000023'] = false;

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
