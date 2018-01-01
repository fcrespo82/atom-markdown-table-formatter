import { expect } from 'chai'
import { TextEditor } from 'atom'
import {
  testFormat,
  testSuite,
  loadPackage,
  settings,
  loadFixture,
} from './utils'
import nonTables = require('./tables/non-tables')
import { sep } from 'path'

const testTables = loadFixture('test-tables')

describe('editor tests', function() {
  beforeEach(async () => {
    await loadPackage()
  })

  const runEditorTests = function(
    grammar: string,
    fixture: string,
    scope: string,
    inopts: {
      addGrammar?: boolean
      selectBeforeTest?: boolean
      crlf?: '\r\n' | '\n'
    } = {},
  ) {
    const defopts = {
      addGrammar: true,
      selectBeforeTest: false,
      crlf: '\n',
    }
    const opts = { ...inopts, ...defopts }

    return describe(`editor tests for ${grammar} with ${JSON.stringify(
      opts.crlf,
    )}`, function() {
      let editor: TextEditor

      function editorFormat(input: string) {
        editor.setText(input)
        if (opts.selectBeforeTest) {
          editor.setSelectedBufferRange(editor.getBuffer().getRange())
        }
        atom.commands.dispatch(
          atom.views.getView(editor),
          'markdown-table-formatter:format',
        )
        return editor.getText()
      }

      function modCrLf(x: string) {
        return x.replace(/\n/g, opts.crlf)
      }

      const test = testFormat(editorFormat, modCrLf)

      beforeEach(async function() {
        await atom.packages.activatePackage(grammar)
        editor = (await atom.workspace.open(
          `${__dirname}${sep}fixtures${sep}${fixture}`,
        )) as TextEditor
        expect(editor).to.exist
        editor.getBuffer().setPreferredLineEnding(opts.crlf)
        if (opts.addGrammar) {
          expect(
            atom.commands.dispatch(
              atom.views.getView(editor),
              'markdown-table-formatter:enable-for-current-scope',
            ),
          ).to.equal(true)
        }
      })

      it(`should ${
        opts.addGrammar ? '' : 'NOT '
      }have ${scope} in grammarScopes`, function() {
        if (opts.addGrammar) {
          return expect(settings('markdownGrammarScopes')).to.contain(scope)
        } else {
          return expect(settings('markdownGrammarScopes')).not.to.contain(scope)
        }
      })

      testSuite(test)

      it("shouldn't try to format non-tables", () =>
        nonTables.map((nonTable: string) =>
          test({ input: nonTable, expected: nonTable }),
        ))

      describe('Tables at the end of document', function() {
        const modTest = testFormat(editorFormat, (text, rand) =>
          modCrLf(
            nonTables[Math.floor(rand * nonTables.length)] + opts.crlf + text,
          ),
        )
        testSuite(modTest)
      })

      describe('Tables at the beginning of document', function() {
        const modTest = testFormat(editorFormat, (text, rand) =>
          modCrLf(
            text + opts.crlf + nonTables[Math.floor(rand * nonTables.length)],
          ),
        )
        testSuite(modTest)
      })

      it('should properly format large text', function() {
        let edtext = ''
        let expected = ''
        for (const table of testTables) {
          const text =
            nonTables[Math.floor(Math.random() * nonTables.length + 1)] || ''
          edtext += opts.crlf + text + opts.crlf + table.input
          expected += opts.crlf + text + opts.crlf + table.expected
        }
        test({ input: edtext, expected })
      })
    })
  }

  runEditorTests('language-gfm', 'empty.md', 'source.gfm')
  runEditorTests('language-text', 'empty.text', 'text.plain.null-grammar')
  runEditorTests('language-gfm', 'empty.md', 'source.gfm', { crlf: '\r\n' })
  runEditorTests('language-text', 'empty.text', 'text.plain.null-grammar', {
    crlf: '\r\n',
  })
  runEditorTests('language-text', 'empty.text', 'text.plain.null-grammar', {
    addGrammar: false,
    selectBeforeTest: true,
  })
})
