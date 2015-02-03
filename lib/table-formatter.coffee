{CompositeDisposable} = require('atom')

module.exports =
class TableFormatter
    subscriptions: []
    #regex: /((.+?)\|)+?(.+)?\r?\n(([:\-\|]+?)\|)+?([:\-\|]+)?[ ]*(\r?\n((.+?)\|)+?(.+)?)+/mg

    constructor: ->
        @subscriptions = new CompositeDisposable
        atom.workspace.observeTextEditors (editor) =>
            @subscriptions.add editor.getBuffer().onWillSave =>
                @format editor, true if atom.config.get("markdown-table-formatter.formatOnSave")

    destroy: ->
        @subscriptions.dispose()

    format: (editor,force) ->
        # console.log(editor.getGrammar().scopeName)
        if editor.getGrammar().scopeName != 'source.gfm'
            # console.log('exiting')
            return

        selectionsRanges = editor.getSelectedBufferRanges()
        # console.log(selectionsRanges[0].isEmpty())

        autoSelectEntireDocument = atom.config.get("markdown-table-formatter.autoSelectEntireDocument")
        # console.log(autoSelectEntireDocument)

        if force or (selectionsRanges[0].isEmpty() and autoSelectEntireDocument)
            # console.log('all selected')
            selectionsRanges = [editor.getBuffer().getRange()]

        # console.log('myIterator')
        myIterator = (obj) =>
            # console.log('iterating')
            obj.replace(@formatTable(obj.match))

        for range in selectionsRanges
            # console.log(@regex)
            # console.log(range)
            # console.log(myIterator)

            editor.backwardsScanInBufferRange(@regex, range, myIterator)

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
        halfWidthLength = (str) -> str.length + (str.match(/[^ -~]/g)?.length or 0)

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

    regex: /((?:(?:[^\n]*?\|[^\n]*) *\r?\n)?)((?:\| *:?-+:? *|\|?(?: *:?-+:? *\|)+)(?: *:?-+:? *)? *\r?\n)((?:(?:[^\n]*?\|[^\n]*) *\r?\n)+)/g
