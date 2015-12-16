MarkdownTableFormatter = require '../lib/markdown-table-formatter'
testTables = require './test-tables'
testTablesDefault = require './test-tables-default'
nonTables = require './non-tables'

describe "markdown-table-formatter", ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('markdown-table-formatter')

  it "should load correctly", ->
    expect(MarkdownTableFormatter).toBeDefined()
    expect(MarkdownTableFormatter.tableFormatter).toBeDefined()

  describe "regex tests", ->
    it "should match the regex", ->
      for table in testTables
        expect(table.test).toMatch(MarkdownTableFormatter.tableFormatter.regex)

    it "should NOT match the regex", ->
      for table in nonTables
        expect(table).not.toMatch(MarkdownTableFormatter.tableFormatter.regex)

  describe "format tests", ->
    rx = null

    beforeEach ->
      rx = MarkdownTableFormatter.tableFormatter.regex
      MarkdownTableFormatter.tableFormatter.spacePadding = 1
      MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
      MarkdownTableFormatter.tableFormatter.defaultTableJustification = 'Left'

    it "should properly format this tables", ->
      for table in testTables
        rx.lastIndex = 0
        rxtable = rx.exec(table.test)
        formatted = MarkdownTableFormatter.tableFormatter.formatTable rxtable
        expect(formatted).toEqual(table.expected)

    describe "Default justification tests", ->
      for just, tbls of testTablesDefault
        it "should properly format this tables with #{just} justification", ->
          MarkdownTableFormatter.tableFormatter.defaultTableJustification = just
          for table in tbls
            rx.lastIndex = 0
            rxtable = rx.exec(table.test)
            formatted = MarkdownTableFormatter.tableFormatter.formatTable rxtable
            expect(formatted).toEqual(table.expected)

  describe "editor tests", ->
    editor = null

    beforeEach ->
      editor = atom.workspace.buildTextEditor()
      editor.getGrammar().scopeName = 'source.gfm'
      MarkdownTableFormatter.tableFormatter.spacePadding = 1
      MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
      MarkdownTableFormatter.tableFormatter.defaultTableJustification = 'Left'
      MarkdownTableFormatter.tableFormatter.autoSelectEntireDocument = true
      MarkdownTableFormatter.tableFormatter.formatOnSave = false

    it "should properly format test tables", ->
      for table in testTables
        editor.setText(table.test)
        MarkdownTableFormatter.tableFormatter.format editor
        expect(editor.getText()).toEqual(table.expected)

    it "shouldn't try to format non-tables", ->
      for nonTable in nonTables
        editor.setText(nonTable)
        MarkdownTableFormatter.tableFormatter.format editor
        expect(editor.getText()).toEqual(nonTable)

    it "should format tables at the end of document", ->
      for table in testTables
        text = nonTables[Math.floor(Math.random() * nonTables.length)]
        editor.setText(text + "\n" + table.test)
        MarkdownTableFormatter.tableFormatter.format editor
        expect(editor.getText()).toEqual(text + "\n" + table.expected)

    it "should format tables at the beginning of document", ->
      for table in testTables
        text = nonTables[Math.floor(Math.random() * nonTables.length)]
        editor.setText(table.test + "\n" + text)
        MarkdownTableFormatter.tableFormatter.format editor
        expect(editor.getText()).toEqual(table.expected + "\n" + text)

    it "should properly format large text", ->
      expected = ""
      for table in testTables
        text = nonTables[Math.floor(Math.random() * nonTables.length)]
        editor.setText(editor.getText() + "\n" + text + "\n" + table.test)
        expected += "\n" + text + "\n" + table.expected
      MarkdownTableFormatter.tableFormatter.format editor
      expect(editor.getText()).toEqual(expected)
