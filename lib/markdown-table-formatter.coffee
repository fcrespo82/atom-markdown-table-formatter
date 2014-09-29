module.exports =
  configDefaults:
    restoreSelections: false
    autoSelectEntireDocument: true

  activate: ->
    atom.workspaceView.command "markdown-table-formatter:format", => @convert()

  convert: ->
    normtable = (text) ->
        just = (string, type, n) ->
            lenght = n - string.length
            if type == '::'
                return ' '.repeat(lenght/2) + string + ' '.repeat((lenght+1)/2)
            else if type == '-:'
                return ' '.repeat(lenght) + string
            else if type == ':-'
                return string + ' '.repeat(lenght)
            else
                return string

        lines = text.split('\n')
        rows = lines.length

        formatline = ''
        formatrow = 0
        for line, i in lines
            if /\|[|:.-]+/.exec(line) != null
                formatline = line
                formatrow = i
                break

        removeFormatRow = (s) ->
             return !/\|[|:.-]+/.exec(s)

        lines = lines.filter(removeFormatRow)

        formatline = formatline.trim().replace(/(^\||\|$)/g,"")
        fstrings = formatline.split('|')
        justify = []
        for cell in fstrings
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
            linecontent = ( ' ' + x.trim() + ' ' for x in cells )
            content.push(linecontent)

        rows = content.length
        for i in rows
            while content[i].length < columns
                content[i].push('')

        widths = []
        widths.push(2) for c in [0..columns-1]

        max = (x, y) -> if x > y then x else y

        for row in content
            for i in [0..columns-1]
                widths[i] = max(row[i].length, widths[i])

        formatted = []
        for row in content
             line = []
             for i in [0..columns-1]
                  text = just(row[i], justify[i], widths[i])
                  line.push(text)
             formatted.push('|' + line.join('|') + '|')

        formattedformatline = []
        for i in [0..columns-1]
           text = justify[i][0] + '-'.repeat((widths[i]-2)) + justify[i][justify[i].length-1]
           formattedformatline.push(text)
        formatline = '|' + formattedformatline.join('|') + '|'

        formatted.splice(formatrow, 0, [formatline]);

        return formatted.join('\n')

    editor = atom.workspace.activePaneItem

    re = /(^\|.*\|$)\n(^\|[\W]+\|$)(\n(^\|.*\|$))+/mg;

    selectionsRanges = editor.getSelectedBufferRanges()
    initialSelectionsRanges = selectionsRanges

    autoSelectEntireDocument = atom.config.get("markdown-table-formatter.autoSelectEntireDocument")

    if selectionsRanges[0].isEmpty() and autoSelectEntireDocument
        editor.selectAll()
        selectionsRanges = editor.getSelectedBufferRanges()

    myIterator = (obj) ->
        obj.replace(normtable(obj.matchText))

    for range in selectionsRanges
        editor.backwardsScanInBufferRange(re, range, myIterator)

    restoreSelections = atom.config.get("markdown-table-formatter.restoreSelections")

    if restoreSelections
        editor.setSelectedBufferRanges(initialSelectionsRanges)
