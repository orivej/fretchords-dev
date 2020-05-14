// Generated by LiveScript 1.6.0
(function(){
  var R, ReactDOM, componentize, DOMImport, notes, tunings, Fretboard, App, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);}, toString$ = {}.toString, this$ = this;
  R = preact;
  ReactDOM = R;
  componentize = function(elem){
    return function(){
      var props, args, arg;
      props = {};
      args = arrayFrom$(arguments);
      while (args.length) {
        arg = args.shift();
        if (toString$.call(arg).slice(8, -1) === 'Object' && !R.isValidElement(arg)) {
          import$(props, arg);
        } else {
          args.unshift(arg);
          break;
        }
      }
      return R.createElement.apply(R, [elem, props].concat(arrayFrom$(args)));
    };
  };
  DOMImport = function(tag){
    return this$[tag] = componentize(tag);
  };
  ['div', 'nav', 'ul', 'ol', 'li', 'p', 'a', 'i', 'b', 'span', 'small', 'br', 'h1', 'h2', 'h3', 'table', 'caption', 'thead', 'tbody', 'tr', 'th', 'td', 'form', 'label', 'input', 'select', 'datalist', 'option', 'button', 'hr', 'img'].forEach(DOMImport);
  notes = {
    '♯': ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B'],
    '♭': ['C', 'D♭', 'D', 'E♭', 'E', 'F', 'G♭', 'G', 'A♭', 'A', 'B♭', 'B']
  };
  tunings = {
    '': '',
    Banjo: 'G4 D3 G3 B3 D4',
    Bass: 'E1 A1 D2 G2',
    Guitar: 'E2 A2 D3 G3 B3 E4',
    Lute: 'D2 F2 G2 C3 F3 A3 D4 G4',
    Ukulele: 'G4 C4 E4 A4',
    Violin: 'G3 D4 A4 E5'
  };
  Fretboard = componentize(Fretboard = (function(superclass){
    var prototype = extend$((import$(Fretboard, superclass).displayName = 'Fretboard', Fretboard), superclass).prototype, constructor = Fretboard;
    Fretboard.prototype.state = {};
    Fretboard.prototype.toggleNote = function(note){
      var ref$;
      return this.setState((ref$ = {}, ref$[note] = !this.state[note], ref$));
    };
    Fretboard.prototype.render = function(){
      var tones, res$, i$, i, j$, ref$, len$, note, strings, x, col, row, rows, this$ = this;
      res$ = [];
      for (i$ = 1; i$ <= 7; ++i$) {
        i = i$;
        for (j$ = 0, len$ = (ref$ = notes[this.props.naming]).length; j$ < len$; ++j$) {
          note = ref$[j$];
          res$.push(note + i);
        }
      }
      tones = res$;
      res$ = [];
      for (i$ = 0, len$ = (ref$ = this.props.tuning.split(' ').reverse()).length; i$ < len$; ++i$) {
        x = ref$[i$];
        if (x) {
          res$.push(tones.indexOf(x));
        }
      }
      strings = res$;
      col = function(i, j){
        var toneOffset, noteOffset;
        toneOffset = strings[i] + j;
        noteOffset = toneOffset % 12;
        return td({
          key: j,
          className: this$.state[noteOffset] ? 'active c' + noteOffset : void 8,
          onClick: function(){
            return this$.toggleNote(noteOffset);
          }
        }, tones[toneOffset]);
      };
      row = function(i){
        var j;
        return tr({
          key: i
        }, (function(){
          var i$, to$, results$ = [];
          for (i$ = 0, to$ = this.props.nfrets; i$ <= to$; ++i$) {
            j = i$;
            results$.push(col(i, j));
          }
          return results$;
        }.call(this$)));
      };
      res$ = [];
      for (i$ = 0, len$ = strings.length; i$ < len$; ++i$) {
        i = i$;
        res$.push(row(i));
      }
      rows = res$;
      return table(tbody(rows));
    };
    function Fretboard(){
      this.render = bind$(this, 'render', prototype);
      this.toggleNote = bind$(this, 'toggleNote', prototype);
      Fretboard.superclass.apply(this, arguments);
    }
    return Fretboard;
  }(R.Component)));
  App = componentize(App = (function(superclass){
    var prototype = extend$((import$(App, superclass).displayName = 'App', App), superclass).prototype, constructor = App;
    App.prototype.state = {
      naming: '♯',
      tuning: tunings.Guitar,
      nnecks: 12,
      nfrets: 12
    };
    App.prototype.onChangeNaming = function(e){
      return this.setState({
        naming: e.target.value
      });
    };
    App.prototype.onChangeTuning = function(e){
      return this.setState({
        tuning: e.target.value
      });
    };
    App.prototype.onChangeNecks = function(e){
      return this.setState({
        nnecks: Number(e.target.value)
      });
    };
    App.prototype.onChangeFrets = function(e){
      return this.setState({
        nfrets: Number(e.target.value)
      });
    };
    App.prototype.render = function(){
      var k, v, i;
      return div(form(label('Naming: ', select({
        value: this.state.naming,
        onChange: this.onChangeNaming
      }, option({
        value: '♯'
      }, '♯'), option({
        value: '♭'
      }, '♭'))), label('Tuning: ', input({
        type: 'search',
        value: this.state.tuning,
        onInput: this.onChangeTuning
      }), select({
        value: this.state.tuning,
        onChange: this.onChangeTuning
      }, (function(){
        var ref$, results$ = [];
        for (k in ref$ = tunings) {
          v = ref$[k];
          results$.push(option({
            key: k,
            value: v
          }, k));
        }
        return results$;
      }()))), label({
        className: 'nnecks'
      }, 'Necks: ', input({
        type: 'number',
        min: 0,
        value: this.state.nnecks,
        onChange: this.onChangeNecks
      })), label({
        className: 'nfrets'
      }, 'Frets: ', input({
        type: 'number',
        min: 0,
        value: this.state.nfrets,
        onChange: this.onChangeFrets
      })), a({
        href: 'https://github.com/orivej/fretchords#usage',
        target: '_blank'
      }, 'Help')), div({
        className: 'fretboards'
      }, (function(){
        var i$, to$, results$ = [];
        for (i$ = 1, to$ = this.state.nnecks; i$ <= to$; ++i$) {
          i = i$;
          results$.push(div({
            key: i,
            className: 'fretboard'
          }, Fretboard(this.state)));
        }
        return results$;
      }.call(this))));
    };
    function App(){
      this.render = bind$(this, 'render', prototype);
      this.onChangeFrets = bind$(this, 'onChangeFrets', prototype);
      this.onChangeNecks = bind$(this, 'onChangeNecks', prototype);
      this.onChangeTuning = bind$(this, 'onChangeTuning', prototype);
      this.onChangeNaming = bind$(this, 'onChangeNaming', prototype);
      App.superclass.apply(this, arguments);
    }
    return App;
  }(R.Component)));
  ReactDOM.render(App(), document.getElementById('main'));
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
}).call(this);

//# sourceMappingURL=index.js.map
