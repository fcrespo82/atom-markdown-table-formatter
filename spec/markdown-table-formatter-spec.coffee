MarkdownTableFormatter = require '../lib/markdown-table-formatter'
testTables = require './test-tables'
testTablesDefault = require './test-tables-default'
nonTables = require './non-tables'

describe 'markdown-table-formatter', ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('markdown-table-formatter')

  it 'should load correctly', ->
    expect(MarkdownTableFormatter).toBeDefined()
    expect(MarkdownTableFormatter.tableFormatter).toBeDefined()

  describe 'regex tests', ->
    it 'should match the regex', ->
      for table in testTables
        expect(table.test).toMatch(MarkdownTableFormatter.tableFormatter.regex)

    it 'should NOT match the regex', ->
      for table in nonTables
        expect(table).not.toMatch(MarkdownTableFormatter.tableFormatter.regex)

  testFormat = (formatter, modifier) -> (input, expected) ->
    modifier ?= (x) -> x
    rand = Math.random()
    expect(formatter modifier(input, rand)).toEqual(modifier(expected, rand))

  testSuiteSingle = (test, tbls) ->
    it 'should properly format these tables', ->
      for table in tbls
        test table.test, table.expected

  testSuite = (test) ->
    testSuiteSingle(test, testTables)

    for just, tbls of testTablesDefault
      describe "Default #{just} justification tests", ->
        do (just) ->
          beforeEach ->
            MarkdownTableFormatter.tableFormatter.defaultTableJustification = just
        testSuiteSingle test, tbls

  describe 'format tests', ->
    test = testFormat (input) ->
      rx = MarkdownTableFormatter.tableFormatter.regex
      rx.lastIndex = 0
      MarkdownTableFormatter.tableFormatter.formatTable rx.exec(input)

    beforeEach ->
      MarkdownTableFormatter.tableFormatter.spacePadding = 1
      MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
      MarkdownTableFormatter.tableFormatter.defaultTableJustification = 'Left'

    testSuite test

  runEditorTests = (grammar, fixture, scope, opts = {}) ->
    opts.addGrammar ?= true
    opts.selectBeforeTest ?= false

    describe "editor tests for #{grammar}", ->
      editor = null

      test = testFormat editorFormat = (input) ->
        editor.setText input
        if opts.selectBeforeTest
          editor.setSelectedBufferRange(editor.getBuffer().getRange())
        atom.commands.dispatch atom.views.getView(editor), 'markdown-table-formatter:format'
        editor.getText()

      beforeEach ->
        grammarPromise = atom.packages.activatePackage(grammar)
        packagePromise = atom.packages.activatePackage('markdown-table-formatter')
        waitsForPromise ->
          Promise.all [grammarPromise, packagePromise]
          .then ->
            {sep} = require 'path'
            atom.workspace.open("#{__dirname}#{sep}fixtures#{sep}#{fixture}")
          .then (ed) ->
            editor = ed
          .then ->
            if opts.addGrammar
              atom.commands.dispatch atom.views.getView(editor), 'markdown-table-formatter:enable-for-current-scope'

      it "should #{if opts.addGrammar then '' else 'NOT '}have #{scope} in grammarScopes", ->
        if opts.addGrammar
          expect(MarkdownTableFormatter.tableFormatter.markdownGrammarScopes).toContain(scope)
        else
          expect(MarkdownTableFormatter.tableFormatter.markdownGrammarScopes).not.toContain(scope)

      testSuite test

      it "shouldn't try to format non-tables", ->
        for nonTable in nonTables
          test nonTable, nonTable

      describe 'Tables at the end of document', ->
        modTest = testFormat editorFormat, (text, rand) ->
          nonTables[Math.floor(rand * nonTables.length)] + '\n' + text
        testSuite modTest

      describe 'Tables at the beginning of document', ->
        modTest = testFormat editorFormat, (text, rand) ->
          text + '\n' + nonTables[Math.floor(rand * nonTables.length)]
        testSuite modTest

      it 'should properly format large text', ->
        edtext = ''
        expected = ''
        for table in testTables
          text = nonTables[Math.floor(Math.random() * nonTables.length)]
          edtext += '\n' + text + '\n' + table.test
          expected += '\n' + text + '\n' + table.expected
        test edtext, expected

  runEditorTests 'language-gfm', 'empty.md', 'source.gfm'
  runEditorTests 'language-text', 'empty.text', 'text.plain.null-grammar'
  runEditorTests 'language-text', 'empty.text', 'text.plain.null-grammar',
    addGrammar: false
    selectBeforeTest: true
