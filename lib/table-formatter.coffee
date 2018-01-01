{CompositeDisposable, Range} = require('atom')
wcswidth = require 'wcwidth'

swidth = (str) ->
  # zero-width Unicode characters that we should ignore for
  # purposes of computing string "display" width
  zwcrx = /[\u200B-\u200D\uFEFF\u00AD]/g
  wcswidth(str) - ( str.match(zwcrx)?.length or 0 )

module.exports =
class TableFormatter
  subscriptions: []

  constructor: ->
    @subscriptions = new CompositeDisposable
    @initConfig()
    atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.getBuffer().onWillSave =>
        @format editor, true if @formatOnSave

  readConfig: (key, scope) ->
    scope ?= 'markdown-table-formatter'
    scopedKey = "#{scope}.#{key}"
    @subscriptions.add atom.config.observe scopedKey, (value) =>
      @[key] = value

  initConfig: ->
    @readConfig 'autoSelectEntireDocument'
    @readConfig 'spacePadding'
    @readConfig 'keepFirstAndLastPipes'
    @readConfig 'formatOnSave'
    @readConfig 'defaultTableJustification'
    @readConfig 'markdownGrammarScopes'
    @readConfig 'limitLastColumnPadding'
    @readConfig 'preferredLineLength', 'editor'

  destroy: ->
    @subscriptions.dispose()

  format: (editor, force) ->
    selectionsRanges = editor.getSelectedBufferRanges()

    bufferRange = editor.getBuffer().getRange()
    selectionsRangesEmpty =
      selectionsRanges.every (i) -> i.isEmpty()
    if not (editor.getGrammar().scopeName in @markdownGrammarScopes) and selectionsRangesEmpty
      return
    if force or (selectionsRangesEmpty and @autoSelectEntireDocument)
      selectionsRanges = [bufferRange]
    else
      selectionsRanges=
        for srange in selectionsRanges when not (srange.isEmpty() and
            @autoSelectEntireDocument)
          start = bufferRange.start
          end = bufferRange.end
          editor.scanInBufferRange /^$/m,
            new Range(srange.start, bufferRange.end),
            ({range}) ->
              end = range.start
          editor.backwardsScanInBufferRange /^$/m,
            new Range(bufferRange.start, srange.end),
            ({range}) ->
              start = range.start
          if end.isLessThan(srange.end)
            end = srange.end
          if start.isGreaterThan(srange.start)
            start = srange.start
          new Range(start, end)

    myIterator = (obj) =>
      editor.setTextInBufferRange(obj.range, @formatTable(obj.match))

    editor.getBuffer().transact =>
      for range in selectionsRanges
        editor.backwardsScanInBufferRange(@regex, range, myIterator)

  formatTable: (text) ->
    padding = (len, str = ' ') -> str.repeat Math.max len, 0

    stripTailPipes = (str) ->
      str.trim().replace /(^\||\|$)/g, ''

    splitCells = (str) ->
      str.split '|'

    addTailPipes = (str) =>
      if @keepFirstAndLastPipes
        "|#{str}|"
      else
        str

    joinCells = (arr) ->
      arr.join '|'

    formatline = text[2].trim()
    headerline = text[1].trim()

    [formatrow, data] =
      if headerline.length is 0
        [ 0, text[3] ]
      else
        [ 1, text[1] + text[3] ]
    lines = data.trim().split(/\r?\n/)

    justify = for cell in splitCells stripTailPipes formatline
      [first, ..., last] = cell.trim()
      switch ends = (first ? ':') + (last ? '-')
        when '::', '-:' then ends
        when '--'
          if @defaultTableJustification == 'Left'
            ':-'
          else if @defaultTableJustification == 'Center'
            '::'
          else if @defaultTableJustification == 'Right'
            '-:'
          else
            ':-'
        else
          ':-'

    columns = justify.length

    content = for line in lines
      cells =  splitCells stripTailPipes line
      #put all extra content into last cell
      cells[columns - 1] = joinCells cells.slice(columns - 1)
      for cell in cells
        padding(@spacePadding) +
        (cell?.trim?() ? '') +
        padding(@spacePadding)

    widths = for i in [0..columns - 1]
      Math.max 2, (swidth(cells[i]) for cells in content)...

    if @limitLastColumnPadding
      sum = (arr) -> arr.reduce (x, y) -> x + y
      wsum = sum(widths)
      if widths.length and wsum > @preferredLineLength
        prewsum = sum(widths[...-1])
        widths[widths.length - 1] = Math.max (@preferredLineLength -
          prewsum -
          widths.length - 1), 3
          # Need at least :-- for github to recognize a column
        console.log widths

    just = (string, col) ->
      length = Math.max widths[col] - swidth(string), 0
      switch justify[col]
        when '::'
          [front, back] = padding
          padding(length / 2) + string + padding((length + 1) / 2)
        when '-:'
          padding(length) + string
        when ':-'
          string + padding(length)
        else
          string

    formatted = for cells in content
      addTailPipes joinCells (just(cells[i], i) for i in [0..columns - 1])

    formatline = addTailPipes joinCells (
      for i in [0..columns - 1]
        [front, back] = justify[i]
        front + padding(widths[i] - 2, '-') + back
      )

    formatted.splice(formatrow, 0, formatline)

    return (if headerline.length is 0 and text[1] isnt '' then '\n' else '') +
      formatted.join('\n') + '\n'

  regex: ///
    ( # header capture
      (?:
        (?:[^\r\n]*?\|[^\r\n]*)       # line w/ at least one pipe
        \ *                       # maybe trailing whitespace
      )?                          # maybe header
      (?:\r?\n|^)                 # newline
    )
    ( # format capture
      (?:
        \|\ *(?::?-+:?|::)\ *            # format starting w/pipe
        |\|?(?:\ *(?::?-+:?|::)\ *\|)+   # or separated by pipe
      )
      (?:\ *(?::?-+:?|::)\ *)?           # maybe w/o trailing pipe
      \ *                         # maybe trailing whitespace
      \r?\n                       # newline
    )
    ( # body capture
      (?:
        (?:[^\r\n]*?\|[^\r\n]*)       # line w/ at least one pipe
        \ *                       # maybe trailing whitespace
        (?:\r?\n|$)               # newline
      )+ # at least one
    )
    ///g
