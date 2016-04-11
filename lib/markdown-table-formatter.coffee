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
          Run \'Editor: Log Cursor Scope\' command to see what grammar scope
          is used by your grammar. Top entry is usually file grammar scope.'
        items:
          type: 'string'

    activate: ->
      @tableFormatter = new TableFormatter()
      #Register command to workspace
      @command = atom.commands.add "atom-text-editor",
        "markdown-table-formatter:format", (event) =>
          editor = event?.target?.getModel?()
          if editor?
            @tableFormatter.format(editor)

    deactivate: ->
      @command.dispose()
      @tableFormatter.destroy()
