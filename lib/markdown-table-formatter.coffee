TableFormatter = require './table-formatter.coffee'

module.exports =
    config:
      formatOnSave:
        type: 'boolean'
        default: true
        description: 'Format tables when document is saved?'
      autoSelectEntireDocument:
        type: 'boolean'
        default: true
        description:
          'Select entire document if selection is empty'
      spacePadding:
        type: 'integer'
        default: 1
        description:
          'How many spaces between left and right of each column content'
      keepFirstAndLastPipes:
        type: 'boolean'
        default: true
        description:
          'Keep first and last pipes "|" in table formatting.
          Tables are easier to format when pipes are kept'
      defaultTableJustification:
        type: 'string'
        default: 'Left'
        enum: ['Left', 'Center', 'Right']
        description:
          'Defines the default justification for tables that have only a
          \'-\' on the formatting line'
      markdownGrammarScopes:
        type: 'array'
        default: ['source.gfm']
        description:
          'File grammar scopes that will be considered Markdown by this package (comma-separated).
          Run \'Markdown Table Formatter: Enable For Current Scope\' command to
          add current editor grammar to this setting.'
        items:
          type: 'string'
      limitLastColumnPadding:
        type: 'boolean'
        default: false
        description:
          'Do not pad the last column to more than your editor\'s
          preferredLineLength setting.'

    activate: ->
      @tableFormatter = new TableFormatter()
      #Register command to workspace
      @command = atom.commands.add 'atom-text-editor',
        'markdown-table-formatter:format': (event) =>
          editor = event.currentTarget.getModel()
          @tableFormatter.format(editor)
        'markdown-table-formatter:enable-for-current-scope': (event) ->
          editor = event.currentTarget.getModel()
          scope = editor.getGrammar().scopeName
          key = 'markdown-table-formatter.markdownGrammarScopes'
          current = atom.config.get(key)
          if not scope? or not scope
            atom.notifications.addError 'Could not determine editor grammar scope'
          else if scope in current
            atom.notifications.addWarning "#{scope} already considered Markdown"
          else
            atom.config.set(key, [current..., scope])
            atom.notifications.addSuccess "Successfully added #{scope} to Markdown scopes"

    deactivate: ->
      @command.dispose()
      @tableFormatter.destroy()
