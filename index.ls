R = preact
ReactDOM = R

componentize = (elem) ->
  ->
    props = {}
    args = [...arguments]
    while args.length
      arg = args.shift!
      if (typeof! arg is 'Object') and (not R.isValidElement arg)
        props <<< arg
      else
        args.unshift arg
        break
    R.createElement elem, props, ...args

DOMImport = (tag) ~>
  @[tag] = componentize tag

<[
  div nav ul ol li p a i b span small br h1 h2 h3
  table caption thead tbody tr th td
  form label input select datalist option button hr img
]>.forEach DOMImport

notes =
  '♯': <[C C♯ D D♯ E F F♯ G G♯ A A♯ B]>
  '♭': <[C D♭ D E♭ E F G♭ G A♭ A B♭ B]>

tunings =
  '': ''
  Banjo: 'G4 D3 G3 B3 D4'
  Bass: 'E1 A1 D2 G2'
  Guitar: 'E2 A2 D3 G3 B3 E4'
  Ukulele: 'G4 C4 E4 A4'
  Violin: 'G3 D4 A4 E5'

Fretboard = componentize class Fretboard extends R.Component
  state: {}
  toggleNote: (note) ~>
    @setState (note): not @state[note]
  render: ~>
    tones = [note + i for i from 1 to 7 for note in notes[@props.naming]]
    strings = [tones.indexOf x for x in @props.tuning.split(' ').reverse() when x]
    col = (i, j) ~>
      tone-offset = strings[i] + j
      note-offset = tone-offset % 12
      td {
        key: j
        className: if @state[note-offset] then 'active c' + note-offset
        onClick: ~> @toggleNote note-offset
      } tones[tone-offset]
    row = (i) ~> tr key: i, [col i, j for j from 0 to @props.nfrets]
    rows = [row i for ,i in strings]
    table tbody rows

App = componentize class App extends R.Component
  state:
    naming: '♯'
    tuning: tunings.Guitar
    nnecks: 12
    nfrets: 12
  onChangeNaming: (e) ~> @setState naming: e.target.value
  onChangeTuning: (e) ~> @setState tuning: e.target.value
  onChangeNecks: (e) ~> @setState nnecks: Number e.target.value
  onChangeFrets: (e) ~> @setState nfrets: Number e.target.value
  render: ~>
    div do
      form do
        label 'Naming: ',
          select value: @state.naming, onChange: @onChangeNaming,
            option value: '♯', '♯'
            option value: '♭', '♭'
        label 'Tuning: ',
          input type: \search, value: @state.tuning, onInput: @onChangeTuning
          select value: @state.tuning, onChange: @onChangeTuning,
            [option key: k, value: v, k for k, v of tunings]
        label className: \nnecks, 'Necks: ',
          input type: \number, min: 0, value: @state.nnecks, onChange: @onChangeNecks
        label className: \nfrets, 'Frets: ',
          input type: \number, min: 0, value: @state.nfrets, onChange: @onChangeFrets
      div className: \fretboards,
        for i from 1 to @state.nnecks
          div key: i, className: \fretboard, Fretboard @state

ReactDOM.render App(), document.getElementById 'main'
