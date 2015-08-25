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

    activate: ->
      @tableFormatter = new TableFormatter()
      #Register command to workspace
      @command = atom.commands.add "atom-text-editor",
        "markdown-table-formatter:format", (event) =>
          @tableFormatter.format(event.target.getModel())

    deactivate: ->
      @command.dispose()
      @tableFormatter.destroy()
