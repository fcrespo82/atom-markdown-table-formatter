{WorkspaceView} = require 'atom'
MarkdownTableFormatter = require '../lib/markdown-table-formatter'

describe "When formatting a table", ->
    beforeEach ->
        waitsForPromise ->
            atom.workspaceView = new WorkspaceView()
            atom.packages.activatePackage('markdown-table-formatter')

    it "should load correctly", ->
        expect(MarkdownTableFormatter).toBeDefined()
        expect(MarkdownTableFormatter.tableFormatter).toBeDefined()

    it "should match the regex", ->
        table = '|Left|Center|Right|\n|:-|::|-:|\n|1|2|3|'
        expect(table).toMatch(MarkdownTableFormatter.regex)

    it "should properly format this table", ->
        table = '|Left|Center|Right|\n|:-|::|-:|\n|1|2|3|'
        expectedTable = '| Left | Center | Right |\n|:-----|:------:|------:|\n| 1    |   2    |     3 |'
        formattedTable = MarkdownTableFormatter.tableFormatter.formatTable(table)
        expect(formattedTable).toEqual(expectedTable)
