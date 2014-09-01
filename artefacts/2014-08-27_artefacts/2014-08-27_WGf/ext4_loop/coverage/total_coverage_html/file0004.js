var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 107</i>';
states['fold000001'] = false;
texts['fold000109'] = '<a href="javascript:fold(\'fold000109\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 109 to line 110</i>';
states['fold000109'] = false;
texts['fold000114'] = '<a href="javascript:fold(\'fold000114\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 114 to line 132</i>';
states['fold000114'] = false;
texts['fold000134'] = '<a href="javascript:fold(\'fold000134\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 134 to line 140</i>';
states['fold000134'] = false;
texts['fold000142'] = '<a href="javascript:fold(\'fold000142\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 142 to line 144</i>';
states['fold000142'] = false;
texts['fold000146'] = '<a href="javascript:fold(\'fold000146\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 146 to line 152</i>';
states['fold000146'] = false;
texts['fold000154'] = '<a href="javascript:fold(\'fold000154\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 154 to line 155</i>';
states['fold000154'] = false;
texts['fold000157'] = '<a href="javascript:fold(\'fold000157\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 157 to line 159</i>';
states['fold000157'] = false;
texts['fold000161'] = '<a href="javascript:fold(\'fold000161\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 161 to line 161</i>';
states['fold000161'] = false;
texts['fold000166'] = '<a href="javascript:fold(\'fold000166\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 166 to line 167</i>';
states['fold000166'] = false;
texts['fold000169'] = '<a href="javascript:fold(\'fold000169\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 169 to line 214</i>';
states['fold000169'] = false;
texts['fold000216'] = '<a href="javascript:fold(\'fold000216\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 216 to line 216</i>';
states['fold000216'] = false;
texts['fold000218'] = '<a href="javascript:fold(\'fold000218\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 218 to line 218</i>';
states['fold000218'] = false;
texts['fold000222'] = '<a href="javascript:fold(\'fold000222\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 222 to line 223</i>';
states['fold000222'] = false;
texts['fold000225'] = '<a href="javascript:fold(\'fold000225\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 225 to line 241</i>';
states['fold000225'] = false;
texts['fold000245'] = '<a href="javascript:fold(\'fold000245\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 245 to line 279</i>';
states['fold000245'] = false;
texts['fold000282'] = '<a href="javascript:fold(\'fold000282\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 282 to line 294</i>';
states['fold000282'] = false;
texts['fold000297'] = '<a href="javascript:fold(\'fold000297\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 297 to line 311</i>';
states['fold000297'] = false;
texts['fold000313'] = '<a href="javascript:fold(\'fold000313\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 313 to line 321</i>';
states['fold000313'] = false;
texts['fold000323'] = '<a href="javascript:fold(\'fold000323\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 323 to line 336</i>';
states['fold000323'] = false;

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
