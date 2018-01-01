import { TableFormatter } from './table-formatter'
import { Disposable } from 'atom'
export { config } from './config'

let tableFormatter: TableFormatter
let command: Disposable

export function activate() {
  tableFormatter = new TableFormatter()
  // Register command to workspace
  command = atom.commands.add('atom-text-editor', {
    'markdown-table-formatter:format': event => {
      const editor = event.currentTarget.getModel()
      tableFormatter.format(editor)
    },
    'markdown-table-formatter:enable-for-current-scope'(event) {
      const editor = event.currentTarget.getModel()
      const scope = editor.getGrammar().scopeName
      const key = 'markdown-table-formatter.markdownGrammarScopes'
      const current = atom.config.get(key)
      if (!scope) {
        atom.notifications.addError('Could not determine editor grammar scope')
      } else if (current.includes(scope)) {
        atom.notifications.addWarning(`${scope} already considered Markdown`)
      } else {
        atom.config.set(key, [...current, scope])
        atom.notifications.addSuccess(
          `Successfully added ${scope} to Markdown scopes`,
        )
      }
    },
  })
}

export function deactivate() {
  command.dispose()
  tableFormatter.destroy()
}
