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

notes = <[C C# D D# E F F# G G# A A# B]>
tones = [note + i for i from 1 to 7 for note in notes]

Fretboard = componentize class Fretboard extends R.Component
  ->
    @state = @model =
      active-notes: {}
  toggleNote: (note) ~>
    @model.active-notes[note] = not @model.active-notes[note]
    @setState @model
  render: ~>
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
      tuning: 'E2 A2 D3 G3 B3 E4'
      nfrets: 12
  onChangeTuning: (e) ~>
    @model.tuning = e.target.value
    @setState @model
  onChangeFrets: (e) ~>
    @model.nfrets = Number e.target.value
    @setState @model
  render: ~>
    div do
      form do
        label 'Tuning: ',
          input type: \search, list: \tunings, value: @state.tuning, onChange: @onChangeTuning
          datalist id: \tunings,
            option value: 'G4 D3 G3 B3 D4', 'Banjo'
            option value: 'E1 A1 D2 G2', 'Bass'
            option value: 'E2 A2 D3 G3 B3 E4', 'Guitar'
            option value: 'G4 C4 E4 A4', 'Ukulele'
            option value: 'G3 D4 A4 E5', 'Violin'
        label className: \nfrets, 'Frets: ',
          input type: \number, min: 0, max: 24, value: @state.nfrets, onChange: @onChangeFrets
      div className: \fretboards,
        for i from 1 to 3*4
          div key: i, className: \fretboard, Fretboard @state

ReactDOM.render App(), document.getElementById 'main'
