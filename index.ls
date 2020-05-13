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
  form label input select option button hr img
]>.forEach DOMImport

notes = <[C C# D D# E F F# G G# A A# B]>
tones = [note + i for i from 2 to 5 for note in notes]
strings = [tones.indexOf x for x in <[E4 B3 G3 D3 A2 E2]>]

Fretboard = componentize class Fretboard extends R.Component
  ->
    @state = @model =
      active-notes: {}
  toggleNote: (note) ~>
    @model.active-notes[note] = not @model.active-notes[note]
    @setState @model
  render: ~>
    col = (i, j) ~>
      tone-offset = strings[i] + j
      note-offset = tone-offset % 12
      td {
        key: j
        className: if @state.active-notes[note-offset] then 'c' + note-offset
        onClick: ~> @toggleNote note-offset
      } tones[tone-offset]
    row = (i) -> tr key: i, [col i, j for j from 0 to 12]
    rows = [row i for i from 0 to 5]
    table tbody rows

App = ->
  for i from 1 to 3*4
    div key: i, className: \fretboard, Fretboard!

ReactDOM.render App(), document.getElementById 'main'
