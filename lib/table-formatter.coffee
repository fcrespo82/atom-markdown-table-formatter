{CompositeDisposable,Range} = require('atom')
wcswidth = require 'wcwidth'

module.exports =
class TableFormatter
  subscriptions: []

  constructor: ->
    @subscriptions = new CompositeDisposable
    @initConfig()
    atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.getBuffer().onWillSave =>
        @format editor, true if @formatOnSave

  readConfig: (key,callback) ->
    key='markdown-table-formatter.'+key
    @subscriptions.add atom.config.onDidChange key, callback
    callback
      newValue: atom.config.get(key)
      oldValue: undefined

  initConfig: () ->
    @readConfig "autoSelectEntireDocument", ({newValue}) =>
      @autoSelectEntireDocument = newValue
    @readConfig "spacePadding", ({newValue}) =>
      @spacePadding = newValue
    @readConfig "keepFirstAndLastPipes", ({newValue}) =>
      @keepFirstAndLastPipes = newValue
    @readConfig "formatOnSave", ({newValue}) =>
      @formatOnSave = newValue

  destroy: ->
    @subscriptions.dispose()

  format: (editor,force) ->
    if editor.getGrammar().scopeName != 'source.gfm'
      return

    selectionsRanges = editor.getSelectedBufferRanges()

    bufferRange=editor.getBuffer().getRange()
    selectionsRangesEmpty =
      selectionsRanges.every (i) -> i.isEmpty()
    if force or (selectionsRangesEmpty and @autoSelectEntireDocument)
      selectionsRanges = [bufferRange]
    else
      selectionsRanges=
        for srange in selectionsRanges when not (srange.isEmpty() and
            @autoSelectEntireDocument)
          start = bufferRange.start
          end = bufferRange.end
          editor.scanInBufferRange /^$/m,
            new Range(srange.start,bufferRange.end),
            ({range})->
              end=range.start
          editor.backwardsScanInBufferRange /^$/m,
            new Range(bufferRange.start,srange.end),
            ({range})->
              start=range.start
          new Range(start,end)

    myIterator = (obj) =>
      obj.replace(@formatTable(obj.match))

    for range in selectionsRanges
      editor.backwardsScanInBufferRange(@regex, range, myIterator)

  formatTable: (text) ->
    just = (string, type, n) ->
      length = n - wcswidth(string)
      if type == '::'
        return ' '.repeat(length/2) + string + ' '.repeat((length+1)/2)
      else if type == '-:'
        return ' '.repeat(length) + string
      else if type == ':-'
        return string + ' '.repeat(length)
      else
        return string

    formatline = text[2].trim()
    headerline = text[1].trim()

    if headerline.length==0
      formatrow=0
      lines = text[3].trim().split('\n')
    else
      formatrow=1
      lines = (text[1]+text[3]).trim().split('\n')
    rows = lines.length

    formatline = formatline.trim().replace(/(^\||\|$)/g,"")
    fstrings = formatline.split('|')
    justify = []
    for cell in fstrings
      cell=cell.trim()
      ends = cell[0] + (cell[cell.length-1] || '')
      if ends == '::'
        justify.push('::')
      else if ends == '-:'
        justify.push('-:')
      else
        justify.push(':-')

    columns = justify.length

    content = []
    for line in lines
      line = line.trim().replace(/(^\||\|$)/g,"")
      cells = line.split('|')
      #put all extra content into last cell
      cells[columns-1]=cells.slice(columns-1).join('|')
      linecontent =
        for x in cells
          ' '.repeat(@spacePadding) +
          x.trim() +
          ' '.repeat(@spacePadding)
      content.push(linecontent)

    rows = content.length
    for i in [0..rows-1]
      while content[i].length < columns
        content[i].push(' ')

    widths = []
    widths.push(2) for c in [0..columns-1]

    max = (x, y) -> if x > y then x else y

    for row in content
      for i in [0..columns-1]
        widths[i] = max(wcswidth(row[i]), widths[i])

    formatted = []
    for row in content
      line = []
      for i in [0..columns-1]
        newtext = just(row[i], justify[i], widths[i])
        line.push(newtext)

      if @keepFirstAndLastPipes
        formatted.push('|' + line.join('|') + '|')
      else
        formatted.push(line.join('|'))

    formattedformatline = []
    for i in [0..columns-1]
      newtext = justify[i][0] +
        '-'.repeat((widths[i]-2)) +
        justify[i][justify[i].length-1]
      formattedformatline.push(newtext)

    if @keepFirstAndLastPipes
      formatline = '|' + formattedformatline.join('|') + '|'
    else
      formatline = formattedformatline.join('|')

    formatted.splice(formatrow, 0, [formatline])
    fmtstr = formatted.join('\n')+'\n'
    fmtstr = '\n'+fmtstr if headerline.length==0 and text[1]!=''
    return fmtstr

  regex: ///
    ( # header capture
      (?:
        (?:[^\n]*?\|[^\n]*)       # line w/ at least one pipe
        \ *                       # maybe trailing whitespace
      )?                          # maybe header
      (?:\r?\n|^)                 # newline
    )
    ( # format capture
      (?:
        \|\ *:?-+:?\ *            # format starting w/pipe
        |\|?(?:\ *:?-+:?\ *\|)+   # or separated by pipe
      )
      (?:\ *:?-+:?\ *)?           # maybe w/o trailing pipe
      \ *                         # maybe trailing whitespace
      \r?\n                       # newline
    )
    ( # body capture
      (?:
        (?:[^\n]*?\|[^\n]*)       # line w/ at least one pipe
        \ *                       # maybe trailing whitespace
        (?:\r?\n|$)               # newline
      )+ # at least one
    )
    ///g
