class TableFormatter
    subscriptions: []
    #regex: /((.+?)\|)+?(.+)?\r?\n(([:\-\|]+?)\|)+?([:\-\|]+)?[ ]*(\r?\n((.+?)\|)+?(.+)?)+/mg
    regex: /((?:(?:[^\n]*?\|[^\n]*) *\r?\n)?)((?:\| *:?-+:? *|\|?(?: *:?-+:? *\|)+)(?: *:?-+:? *)? *\r?\n)((?:(?:[^\n]*?\|[^\n]*) *\r?\n)+)/g

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
            obj.replace(@formatTable(obj.match))

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
        
        halfWidthLength = (str) -> if str.match(/[^ -~]/g) is null then str.length else str.length + str.match(/[^ -~]/g).length

        for row in content
            for i in [0..columns-1]
                widths[i] = max(halfWidthLength(row[i]), widths[i])

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

        return formatted.join('\n')+'\n'

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
