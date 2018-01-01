import { CompositeDisposable, Range, TextEditor, BufferScanResult } from 'atom'
import { regex } from './regex'
import { formatTable } from './formatTable'

export function getAllSettings() {
  return atom.config.get('markdown-table-formatter')
}

export class TableFormatter {
  private readonly subscriptions = new CompositeDisposable()
  constructor() {
    atom.workspace.observeTextEditors(editor =>
      this.subscriptions.add(
        editor.getBuffer().onWillSave(() => {
          if (atom.config.get('markdown-table-formatter.formatOnSave')) {
            this.format(editor, true)
          }
        }),
      ),
    )
  }

  public destroy() {
    this.subscriptions.dispose()
  }

  public format(editor: TextEditor, force: boolean = false) {
    let selectionsRanges = editor.getSelectedBufferRanges()
    const settings = getAllSettings()

    const bufferRange = editor.getBuffer().getRange()
    const selectionsRangesEmpty = selectionsRanges.every(i => i.isEmpty())
    if (
      !settings.markdownGrammarScopes.includes(editor.getGrammar().scopeName) &&
      selectionsRangesEmpty
    ) {
      return undefined
    }
    if (force || (selectionsRangesEmpty && settings.autoSelectEntireDocument)) {
      selectionsRanges = [bufferRange]
    } else {
      selectionsRanges = selectionsRanges
        .filter(
          srange => !(srange.isEmpty() && settings.autoSelectEntireDocument),
        )
        .map(srange => {
          let { start } = bufferRange
          let { end } = bufferRange
          editor.scanInBufferRange(
            /^$/m,
            new Range(srange.start, bufferRange.end),
            ({ range }) => (end = range.start),
          )
          editor.backwardsScanInBufferRange(
            /^$/m,
            new Range(bufferRange.start, srange.end),
            ({ range }) => (start = range.start),
          )
          if (end.isLessThan(srange.end)) end = srange.end
          if (start.isGreaterThan(srange.start)) start = srange.start
          return new Range(start, end)
        })
    }

    return editor.getBuffer().transact(() =>
      selectionsRanges.map(range =>
        editor.backwardsScanInBufferRange(regex, range, function(
          obj: BufferScanResult,
        ) {
          return editor.setTextInBufferRange(
            obj.range,
            formatTable(obj.match, settings),
          )
        }),
      ),
    )
  }
}
