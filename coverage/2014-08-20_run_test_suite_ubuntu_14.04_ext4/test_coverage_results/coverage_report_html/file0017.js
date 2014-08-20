var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 5</i>';
states['fold000001'] = false;
texts['fold000008'] = '<a href="javascript:fold(\'fold000008\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 8 to line 8</i>';
states['fold000008'] = false;
texts['fold000011'] = '<a href="javascript:fold(\'fold000011\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 11 to line 30</i>';
states['fold000011'] = false;
texts['fold000033'] = '<a href="javascript:fold(\'fold000033\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 33 to line 34</i>';
states['fold000033'] = false;
texts['fold000037'] = '<a href="javascript:fold(\'fold000037\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 37 to line 38</i>';
states['fold000037'] = false;
texts['fold000041'] = '<a href="javascript:fold(\'fold000041\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 41 to line 45</i>';
states['fold000041'] = false;
texts['fold000049'] = '<a href="javascript:fold(\'fold000049\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 49 to line 51</i>';
states['fold000049'] = false;
texts['fold000053'] = '<a href="javascript:fold(\'fold000053\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 53 to line 53</i>';
states['fold000053'] = false;
texts['fold000056'] = '<a href="javascript:fold(\'fold000056\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 56 to line 61</i>';
states['fold000056'] = false;
texts['fold000064'] = '<a href="javascript:fold(\'fold000064\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 64 to line 64</i>';
states['fold000064'] = false;
texts['fold000066'] = '<a href="javascript:fold(\'fold000066\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 66 to line 66</i>';
states['fold000066'] = false;
texts['fold000068'] = '<a href="javascript:fold(\'fold000068\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 68 to line 72</i>';
states['fold000068'] = false;
texts['fold000075'] = '<a href="javascript:fold(\'fold000075\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 75 to line 76</i>';
states['fold000075'] = false;
texts['fold000078'] = '<a href="javascript:fold(\'fold000078\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 78 to line 78</i>';
states['fold000078'] = false;
texts['fold000084'] = '<a href="javascript:fold(\'fold000084\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 84 to line 84</i>';
states['fold000084'] = false;
texts['fold000087'] = '<a href="javascript:fold(\'fold000087\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 87 to line 89</i>';
states['fold000087'] = false;
texts['fold000092'] = '<a href="javascript:fold(\'fold000092\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 92 to line 95</i>';
states['fold000092'] = false;
texts['fold000098'] = '<a href="javascript:fold(\'fold000098\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 98 to line 104</i>';
states['fold000098'] = false;
texts['fold000108'] = '<a href="javascript:fold(\'fold000108\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 108 to line 111</i>';
states['fold000108'] = false;
texts['fold000113'] = '<a href="javascript:fold(\'fold000113\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 113 to line 116</i>';
states['fold000113'] = false;
texts['fold000119'] = '<a href="javascript:fold(\'fold000119\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 119 to line 119</i>';
states['fold000119'] = false;
texts['fold000122'] = '<a href="javascript:fold(\'fold000122\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 122 to line 123</i>';
states['fold000122'] = false;
texts['fold000125'] = '<a href="javascript:fold(\'fold000125\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 125 to line 129</i>';
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
