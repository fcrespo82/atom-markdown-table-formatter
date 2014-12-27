class TableFormatter
    subscriptions: []
    #regex: /((.+?)\|)+?(.+)?\r?\n(([:\-\|]+?)\|)+?([:\-\|]+)?[ ]*(\r?\n((.+?)\|)+?(.+)?)+/mg
    regex: /((.+?)\|)+?(.+)?\r?\n(([\s:\-\|]+?)\|)+?([\s:\-\|]+)?[ ]*(\r?\n((.+?)\|)+?(.+)?)+/mg

    constructor: ->
        atom.workspace.observeTextEditors (editor) =>
            subscription = editor.getBuffer().onWillSave =>
                @format editor
                @subscriptions.push(subscription)
                # # console.log(@subscriptions)

    destroy: ->
        for subscription in @subscriptions
            subscription.dispose()

    format: (editor) ->
        # console.log(editor.getGrammar().scopeName)
        if editor.getGrammar().scopeName != 'source.gfm'
            # console.log('exiting')
            return

        selectionsRanges = editor.getSelectedBufferRanges()
        # console.log(selectionsRanges)
        initialSelectionsRanges = selectionsRanges

        autoSelectEntireDocument = atom.config.get("markdown-table-formatter.autoSelectEntireDocument")

        autoSelected = false
        if selectionsRanges[0].isEmpty() and autoSelectEntireDocument
            # console.log('all selected')
            editor.selectAll()
            autoSelected = true
            selectionsRanges = editor.getSelectedBufferRanges()

        # console.log('myIterator')
        myIterator = (obj) =>
            # console.log('iterating')
            obj.replace(@formatTable(obj.matchText))

        for range in selectionsRanges
            # console.log(@regex)
            # console.log(range)
            # console.log(myIterator)

            editor.backwardsScanInBufferRange(@regex, range, myIterator)

        restoreSelections = atom.config.get("markdown-table-formatter.restoreSelections")

        if restoreSelections
            editor.setSelectedBufferRanges(initialSelectionsRanges)

        if autoSelectEntireDocument and autoSelected
            for selection in editor.getSelections()
                selection.clear()
            editor.setSelectedBufferRanges(initialSelectionsRanges)

    formatTable: (text) ->
        # console.log(text)
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

        formatline = lines[1]
        formatrow = 1
        for line, i in lines
            # Add suport for analphabetic char
            if !/(\w|[^\s\-\|\:])/.exec(line)
                formatline = line
                formatrow = i
                # console.log(formatline)
                # console.log(formatrow)
                break

        removeFormatRow = (s) ->
             # Add suport for analphabetic char
             return /(\w|[^\s\-\|\:])/.exec(s)

        lines = lines.filter(removeFormatRow)
        # console.log(lines)

        formatline = formatline.trim().replace(/(^\||\|$)/g,"")
        fstrings = formatline.split('|')
        justify = []
        for cell in fstrings
            ends = cell[0] + (cell[cell.length-1] || '')
            # Change default alignment to Center
            if ends == ':-'
                justify.push(':-')
            else if ends == '-:'
                justify.push('-:')
            else
                justify.push('::')

        columns = justify.length

        spacePadding = atom.config.get("markdown-table-formatter.spacePadding")

        content = []
        for line in lines
            line = line.trim().replace(/(^\||\|$)/g,"")
            cells = line.split('|')
            linecontent = ( ' '.repeat(spacePadding) + x.trim() + ' '.repeat(spacePadding) for x in cells )
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
                widths[i] = max(row[i].length, widths[i])

        formatted = []
        for row in content
            line = []
            for i in [0..columns-1]
                text = just(row[i], justify[i], widths[i])
                line.push(text)

            keepFirstAndLastPipes = atom.config.get("markdown-table-formatter.keepFirstAndLastPipes")

            if keepFirstAndLastPipes
                formatted.push('|' + line.join('|') + '|')
            else
                formatted.push(line.join('|'))

        formattedformatline = []
        for i in [0..columns-1]
           text = justify[i][0] + '-'.repeat((widths[i]-2)) + justify[i][justify[i].length-1]
           formattedformatline.push(text)
        #formatline = '|' + formattedformatline.join('|') + '|'

        if keepFirstAndLastPipes
            formatline = '|' + formattedformatline.join('|') + '|'
        else
            formatline = formattedformatline.join('|')

        formatted.splice(formatrow, 0, [formatline]);

        return formatted.join('\n')

module.exports =
    config:
        restoreSelections:
            type: 'boolean'
            default: false
            description: 'Restore your selections? Could select incorrect/incomplete text'
        autoSelectEntireDocument:
            type: 'boolean'
            default: true
            description: 'Select entire document if selection is empty'
        spacePadding:
            type: 'integer'
            default: 1
            description: 'How many spaces between left and right of each column content'
        keepFirstAndLastPipes:
            type: 'boolean'
            default: true
            description: 'Keep first and last pipes "|" in table formatting.\nTables are easier to format when pipes are kept'

    activate: ->
        #Register command to workspace
        atom.workspaceView.command "markdown-table-formatter:format", =>
            @format()
        @tableFormatter = new TableFormatter()

    format: ->
        editor = atom.workspace.activePaneItem
        @tableFormatter.format editor
