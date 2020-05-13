R = React

componentize = (elem) ->
  ->
    props = {}
    args = [...arguments]
    while args.length
      arg = args.shift!
      if (typeof! arg is 'Object') and (not React.isValidElement arg)
        props <<< arg
      else
        args.unshift arg
        break
    React.createElement elem, props, ...args

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
  ->
    @state = @model =
      active-notes: {}
  toggleNote: (note) ~>
    @model.active-notes[note] = not @model.active-notes[note]
    @setState @model
  render: ~>
    tones = [note + i for i from 1 to 7 for note in notes[@props.naming]]
    strings = [tones.indexOf x for x in @props.tuning.split(' ').reverse() when x]
    col = (i, j) ~>
      tone-offset = strings[i] + j
      note-offset = tone-offset % 12
      td {
        key: j
        className: if @state.active-notes[note-offset] then 'active c' + note-offset
        onClick: ~> @toggleNote note-offset
      } tones[tone-offset]
    row = (i) ~> tr key: i, [col i, j for j from 0 to @props.nfrets]
    rows = [row i for ,i in strings]
    table tbody rows

App = componentize class App extends R.Component
  ->
    @state = @model =
      naming: '♯'
      tuning: tunings.Guitar
      nfrets: 12
      nboards: 12
  onChangeNaming: (e) ~> @setState naming: e.target.value
  onChangeTuning: (e) ~> @setState tuning: e.target.value
  onChangeFrets: (e) ~> @setState nfrets: Number e.target.value
  onChangeBoards: (e) ~> @setState nboards: Number e.target.value
  render: ~>
    div do
      form do
        label 'Naming: ',
          select value: @state.naming, onChange: @onChangeNaming,
            option value: '♯', '♯'
            option value: '♭', '♭'
        label 'Tuning: ',
          input type: \search, value: @state.tuning, onChange: @onChangeTuning
          select value: @state.tuning, onChange: @onChangeTuning,
            [option key: k, value: v, k for k, v of tunings]
        label className: \nfrets, 'Frets: ',
          input type: \number, min: 0, max: 24, value: @state.nfrets, onChange: @onChangeFrets
        label className: \nboards, 'Boards: ',
          input type: \number, min: 1, value: @state.nboards, onChange: @onChangeBoards
      div className: \fretboards,
        for i from 1 to @state.nboards
          div key: i, className: \fretboard, Fretboard @state

ReactDOM.render App(), document.getElementById 'main'
