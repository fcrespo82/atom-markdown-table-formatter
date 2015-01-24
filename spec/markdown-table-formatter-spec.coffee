{TextEditor} = require 'atom'
MarkdownTableFormatter = require '../lib/markdown-table-formatter'

describe "When formatting a table", ->
    testTable='|Left|Center|Right|\n|:-|:-:|-:|\n|1|2|3|\n'
    expectedTable = '| Left | Center | Right |\n|:-----|:------:|------:|\n| 1    |   2    |     3 |\n'
    beforeEach ->
        waitsForPromise ->
            atom.packages.activatePackage('markdown-table-formatter')

    it "should load correctly", ->
        expect(MarkdownTableFormatter).toBeDefined()
        expect(MarkdownTableFormatter.tableFormatter).toBeDefined()

    it "should match the regex", ->
        expect(testTable).toMatch(MarkdownTableFormatter.tableFormatter.regex)

    it "should properly format this table", ->
      table = MarkdownTableFormatter.tableFormatter.regex.exec testTable
      formatted=MarkdownTableFormatter.tableFormatter.formatTable table
      expect(formatted).toEqual(expectedTable)

    it "should properly work with editor", ->
      editor=new TextEditor(atom.workspace)
      editor.getGrammar().scopeName='source.gfm'
      editor.setText(testTable+"asd\n\n"+testTable)
      MarkdownTableFormatter.tableFormatter.format editor
      expect(editor.getText()).toEqual(expectedTable+"asd\n\n"+expectedTable)
