var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 116</i>';
states['fold000001'] = false;
texts['fold000118'] = '<a href="javascript:fold(\'fold000118\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 118 to line 131</i>';
states['fold000118'] = false;
texts['fold000133'] = '<a href="javascript:fold(\'fold000133\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 133 to line 230</i>';
states['fold000133'] = false;
texts['fold000232'] = '<a href="javascript:fold(\'fold000232\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 232 to line 235</i>';
states['fold000232'] = false;
texts['fold000238'] = '<a href="javascript:fold(\'fold000238\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 238 to line 238</i>';
states['fold000238'] = false;
texts['fold000241'] = '<a href="javascript:fold(\'fold000241\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 241 to line 243</i>';
states['fold000241'] = false;
texts['fold000245'] = '<a href="javascript:fold(\'fold000245\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 245 to line 313</i>';
states['fold000245'] = false;
texts['fold000315'] = '<a href="javascript:fold(\'fold000315\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 315 to line 383</i>';
states['fold000315'] = false;
texts['fold000385'] = '<a href="javascript:fold(\'fold000385\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 385 to line 435</i>';
states['fold000385'] = false;
texts['fold000437'] = '<a href="javascript:fold(\'fold000437\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 437 to line 539</i>';
states['fold000437'] = false;
texts['fold000541'] = '<a href="javascript:fold(\'fold000541\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 541 to line 631</i>';
states['fold000541'] = false;
texts['fold000633'] = '<a href="javascript:fold(\'fold000633\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 633 to line 669</i>';
states['fold000633'] = false;
texts['fold000671'] = '<a href="javascript:fold(\'fold000671\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 671 to line 676</i>';
states['fold000671'] = false;
texts['fold000678'] = '<a href="javascript:fold(\'fold000678\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 678 to line 683</i>';
states['fold000678'] = false;
texts['fold000685'] = '<a href="javascript:fold(\'fold000685\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 685 to line 691</i>';
states['fold000685'] = false;
texts['fold000693'] = '<a href="javascript:fold(\'fold000693\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 693 to line 704</i>';
states['fold000693'] = false;
texts['fold000706'] = '<a href="javascript:fold(\'fold000706\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 706 to line 748</i>';
states['fold000706'] = false;

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
