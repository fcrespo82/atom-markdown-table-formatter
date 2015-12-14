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
            'Defines the default justification for tables that have only a \'-\' on the formatting line'

    activate: ->
      @tableFormatter = new TableFormatter()
      #Register command to workspace
      @command = atom.commands.add "atom-text-editor",
        "markdown-table-formatter:format", (event) =>
          @tableFormatter.format(event.target.getModel())

    deactivate: ->
      @command.dispose()
      @tableFormatter.destroy()
