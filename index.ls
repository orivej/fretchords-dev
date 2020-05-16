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
  div nav ul ol li p a i b span small sub br h1 h2 h3
  table caption thead tbody tfoot tr th td
  form label input select datalist option button hr img
]>.forEach DOMImport

note-offsets = C: 0, D: 2, E: 4, F: 5, G: 7, A: 9, B: 11

notes =
  '♯': <[C C♯ D D♯ E F F♯ G G♯ A A♯ B]>
  '♭': <[C D♭ D E♭ E F G♭ G A♭ A B♭ B]>

tunings =
  '': ''
  Banjo: 'G4 D3 G3 B3 D4'
  Bass: 'E1 A1 D2 G2'
  Guitar: 'E2 A2 D3 G3 B3 E4'
  Lute: 'D2 F2 G2 C3 F3 A3 D4 G4'
  Ukulele: 'G4 C4 E4 A4'
  Violin: 'G3 D4 A4 E5'

rx-tone = /([A-G])(?:([#♯])|([b♭]))?([0-9])?/

parse-tone = (s) ->
  if m = rx-tone.exec s.toUpperCase!
    [s, note, sharp, flat, octave] = m
    Number(octave or 1) * 12 + note-offsets[note] + switch | sharp => 1 | flat => -1 | _ => 0

format-tone = (tone, naming) ->
  note = notes[naming][tone % 12]
  [note[0], span className: \ss, note[1], br!, Math.floor (tone / 12)]

Fretboard = componentize class Fretboard extends R.Component
  state: {}
  toggleNote: (note) ~>
    @setState (note): not @state[note]
  render: ~>
    strings = @props.tuning.split(' ').reverse!.map(parse-tone).filter((!= undefined))
    col = (i, j) ~>
      tone-offset = strings[i] + j
      note-offset = tone-offset % 12
      td {
        key: j
        className: if @state[note-offset] then 'active c' + note-offset
        onClick: ~> @toggleNote note-offset
      } format-tone tone-offset, @props.naming
    row = (i) ~> tr key: i, [col i, j for j from 0 to @props.nfrets]
    table do
      tbody [row i for ,i in strings]
      tfoot tr [td j for j from 0 to @props.nfrets]

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
    radio = (name, value) ~> input type: \radio, name: name, value: value,
      checked: @state[name] == value, onChange: ~> @setState (name): value
    div do
      form do
        label (radio \naming, '♯'), '♯'
        label (radio \naming, '♭'), '♭'
        label 'Tuning: ',
          input type: \search, value: @state.tuning, onInput: @onChangeTuning
          select value: @state.tuning, onChange: @onChangeTuning,
            [option key: k, value: v, k for k, v of tunings]
        label className: \nnecks, 'Necks: ',
          input type: \number, min: 0, value: @state.nnecks, onChange: @onChangeNecks
        label className: \nfrets, 'Frets: ',
          input type: \number, min: 0, value: @state.nfrets, onChange: @onChangeFrets
        a href: 'https://github.com/orivej/fretchords#usage', target: '_blank', 'Help'
      div className: \fretboards,
        for i from 1 to @state.nnecks
          div key: i, className: \fretboard, Fretboard @state

ReactDOM.render App(), document.getElementById 'main'
