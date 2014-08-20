var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 47</i>';
states['fold000001'] = false;
texts['fold000050'] = '<a href="javascript:fold(\'fold000050\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 50 to line 54</i>';
states['fold000050'] = false;
texts['fold000061'] = '<a href="javascript:fold(\'fold000061\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 61 to line 61</i>';
states['fold000061'] = false;
texts['fold000064'] = '<a href="javascript:fold(\'fold000064\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 64 to line 96</i>';
states['fold000064'] = false;
texts['fold000098'] = '<a href="javascript:fold(\'fold000098\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 98 to line 98</i>';
states['fold000098'] = false;
texts['fold000100'] = '<a href="javascript:fold(\'fold000100\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 100 to line 101</i>';
states['fold000100'] = false;
texts['fold000103'] = '<a href="javascript:fold(\'fold000103\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 103 to line 104</i>';
states['fold000103'] = false;
texts['fold000107'] = '<a href="javascript:fold(\'fold000107\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 107 to line 109</i>';
states['fold000107'] = false;
texts['fold000113'] = '<a href="javascript:fold(\'fold000113\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 113 to line 114</i>';
states['fold000113'] = false;
texts['fold000116'] = '<a href="javascript:fold(\'fold000116\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 116 to line 116</i>';
states['fold000116'] = false;
texts['fold000119'] = '<a href="javascript:fold(\'fold000119\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 119 to line 121</i>';
states['fold000119'] = false;
texts['fold000125'] = '<a href="javascript:fold(\'fold000125\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 125 to line 127</i>';
states['fold000125'] = false;
texts['fold000129'] = '<a href="javascript:fold(\'fold000129\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 129 to line 129</i>';
states['fold000129'] = false;
texts['fold000131'] = '<a href="javascript:fold(\'fold000131\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 131 to line 142</i>';
states['fold000131'] = false;
texts['fold000144'] = '<a href="javascript:fold(\'fold000144\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 144 to line 145</i>';
states['fold000144'] = false;
texts['fold000147'] = '<a href="javascript:fold(\'fold000147\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 147 to line 147</i>';
states['fold000147'] = false;
texts['fold000150'] = '<a href="javascript:fold(\'fold000150\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 150 to line 153</i>';
states['fold000150'] = false;
texts['fold000157'] = '<a href="javascript:fold(\'fold000157\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 157 to line 176</i>';
states['fold000157'] = false;
texts['fold000178'] = '<a href="javascript:fold(\'fold000178\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 178 to line 184</i>';
states['fold000178'] = false;
texts['fold000186'] = '<a href="javascript:fold(\'fold000186\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 186 to line 187</i>';
states['fold000186'] = false;
texts['fold000189'] = '<a href="javascript:fold(\'fold000189\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 189 to line 191</i>';
states['fold000189'] = false;
texts['fold000197'] = '<a href="javascript:fold(\'fold000197\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 197 to line 197</i>';
states['fold000197'] = false;
texts['fold000203'] = '<a href="javascript:fold(\'fold000203\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 203 to line 203</i>';
states['fold000203'] = false;
texts['fold000210'] = '<a href="javascript:fold(\'fold000210\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 210 to line 220</i>';
states['fold000210'] = false;

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
