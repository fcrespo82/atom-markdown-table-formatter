MarkdownTableFormatter = require '../lib/markdown-table-formatter'

describe "When formatting a table", ->
  testTables = [
    test: """
      |Left|Center|Right|
      |:-|:-:|-:|
      |1|2|3|

      """
    expected: """
      | Left | Center | Right |
      |:-----|:------:|------:|
      | 1    |   2    |     3 |

      """
  ,
    test: """
      | h1 h1| h2 | h3 |
      |-|-|-|
      | data1 | data2 | data3 |

      """
    expected: """
      | h1 h1 | h2    | h3    |
      |:------|:------|:------|
      | data1 | data2 | data3 |

      """
  ,
    test: """
      h1 | h2 | h3
      -|-|-
      data-1 | data-2 | data-3

      """
    expected: """
      | h1     | h2     | h3     |
      |:-------|:-------|:-------|
      | data-1 | data-2 | data-3 |

      """
  ,
    test: """
      -|-|-
      a|b|c

      """
    expected: """
      |:--|:--|:--|
      | a | b | c |

      """
  ,
    test: """
      | Header 1 | Header 2 | Header 3 |
      |----|---|-|
      | data1a | Data is longer than header | 1 |
      | d1b | add a cell|
      |lorem|ipsum|3|
      | | empty outside cells
      | skip| | 5 |
      | six | Morbi purus | 6 |

      """
    expected: """
      | Header 1 | Header 2                   | Header 3 |
      |:---------|:---------------------------|:---------|
      | data1a   | Data is longer than header | 1        |
      | d1b      | add a cell                 |          |
      | lorem    | ipsum                      | 3        |
      |          | empty outside cells        |          |
      | skip     |                            | 5        |
      | six      | Morbi purus                | 6        |

      """
  ,
    test: """
      |teste-3|
      |---|
      |other|

      """
    expected: """
      | teste-3 |
      |:--------|
      | other   |

      """
  ,
    test: """
      |outro
      |-
      |teste

      """
    expected: """
      | outro |
      |:------|
      | teste |

      """
  ,
    test: """
      outro|
      :-:|
      teste|

      """
    expected: """
      | outro |
      |:-----:|
      | teste |

      """
  ,
    test: """
      First Header  | Second Header
      ------------- | -------------
      Content Cell  | Content Cell
      Content Cell  | Content Cell

      """
    expected: """
      | First Header | Second Header |
      |:-------------|:--------------|
      | Content Cell | Content Cell  |
      | Content Cell | Content Cell  |

      """
  ,
    test: """
      | First Header  | Second Header |
      | ------------- | ------------- |
      | Content Cell  | Content Cell  |
      | Content Cell  | Content Cell  |

      """
    expected: """
      | First Header | Second Header |
      |:-------------|:--------------|
      | Content Cell | Content Cell  |
      | Content Cell | Content Cell  |

      """
  ,
    test: """
      | First Header  | Second Header |
      | ------------- | ------------- |
      | Content Cell  | Content Cell  |
      | Content Cell  | Content Cell  |

      """
    expected: """
      | First Header | Second Header |
      |:-------------|:--------------|
      | Content Cell | Content Cell  |
      | Content Cell | Content Cell  |

      """
  ,
    test: """
      | Item      | Value |
      | --------- | -----:|
      | Computer  | $1600 |
      | Phone     |   $12 |
      | Pipe      |    $1 |

      """
    expected: """
      | Item     | Value |
      |:---------|------:|
      | Computer | $1600 |
      | Phone    |   $12 |
      | Pipe     |    $1 |

      """
  ,
    test: """
      | Function name | Description                    |
      | ------------- | ------------------------------ |
      | `help()`      | Display the help window.       |
      | `destroy()`   | **Destroy your computer!**     |

      """
    expected: """
      | Function name | Description                |
      |:--------------|:---------------------------|
      | `help()`      | Display the help window.   |
      | `destroy()`   | **Destroy your computer!** |

      """
  ,
    test: """
      | Left align | Right align | Center align |
      |:-----------|------------:|:------------:|
      | This       |        This |     This     |
      | column     |      column |    column    |
      | will       |        will |     will     |
      | be         |          be |      be      |
      | left       |       right |    center    |
      | aligned    |     aligned |   aligned    |

      """
    expected: """
      | Left align | Right align | Center align |
      |:-----------|------------:|:------------:|
      | This       |        This |     This     |
      | column     |      column |    column    |
      | will       |        will |     will     |
      | be         |          be |      be      |
      | left       |       right |    center    |
      | aligned    |     aligned |   aligned    |

      """
  ,
    test: """
      |Left align|Right align|Center align|
      |:---------|----------:|:----------:|
      |This|This|This|
      |column|column|column|
      |will|will|will|
      |be|be|be|
      |left|right|center|
      |aligned|aligned|aligned|

      """
    expected: """
      | Left align | Right align | Center align |
      |:-----------|------------:|:------------:|
      | This       |        This |     This     |
      | column     |      column |    column    |
      | will       |        will |     will     |
      | be         |          be |      be      |
      | left       |       right |    center    |
      | aligned    |     aligned |   aligned    |

      """
  ,
    test: """
      First Header  | Second Header
      ------------- | -------------
      Content Cell  | Content Cell
      Content Cell  | Content Cell

      """
    expected: """
      | First Header | Second Header |
      |:-------------|:--------------|
      | Content Cell | Content Cell  |
      | Content Cell | Content Cell  |

      """
  ,
    test: """
      First Header  | Second Header
      ------------- | -------------
      Content Cell  | Content Cell
      Content Cell  | Content Cell

      """
    expected: """
      | First Header | Second Header |
      |:-------------|:--------------|
      | Content Cell | Content Cell  |
      | Content Cell | Content Cell  |

      """
  ,
    test: """
      | First Header  | Second Header |
      | ------------- | ------------- |
      | Content Cell  | Content Cell  |
      | Content Cell  | Content Cell  |

      """
    expected: """
      | First Header | Second Header |
      |:-------------|:--------------|
      | Content Cell | Content Cell  |
      | Content Cell | Content Cell  |

      """
  ,
    test: """
      | Name | Description          |
      | ------------- | ----------- |
      | Help      | Display the help window.|
      | Close     | Closes a window     |

      """
    expected: """
      | Name  | Description              |
      |:------|:-------------------------|
      | Help  | Display the help window. |
      | Close | Closes a window          |

      """
  ,
    test: """
      | Name | Description          |
      | ------------- | ----------- |
      | Help      | ~~Display the~~ help window.|
      | Close     | _Closes_ a window     |

      """
    expected: """
      | Name  | Description                  |
      |:------|:-----------------------------|
      | Help  | ~~Display the~~ help window. |
      | Close | _Closes_ a window            |

      """
  ,
    test: """
      | Left-Aligned  | Center Aligned  | Right Aligned |
      | :------------ |:---------------:| -----:|
      | col 3 is      | some wordy text | $1600 |
      | col 2 is      | centered        |   $12 |
      | zebra stripes | are neat        |    $1 |

      """
    expected: """
      | Left-Aligned  | Center Aligned  | Right Aligned |
      |:--------------|:---------------:|--------------:|
      | col 3 is      | some wordy text |         $1600 |
      | col 2 is      |    centered     |           $12 |
      | zebra stripes |    are neat     |            $1 |

      """
  ,
    test: """
      | First Header | Second Header |         Third Header |
      | :----------- | :-----------: | -------------------: |
      | First row    |      Data     | Very long data entry |
      | Second row   |    **Cell**   |               *Cell* |

      """
    expected: """
      | First Header | Second Header |         Third Header |
      |:-------------|:-------------:|---------------------:|
      | First row    |     Data      | Very long data entry |
      | Second row   |   **Cell**    |               *Cell* |

      """
  ,
    test: """
      |Coffee||
      |:---|:---|
      |Origin/Name|[prompt:Origin/Name]|
      |Brew method|[list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other]|
      |Brewer|[prompt:Who brewed it?]|
      |Rating|[list:Rating|★☆☆|★★☆|★★★]|
      |Notes|[prompt:Notes]|

      """
    expected: """
      | Coffee      |                                                                                |
      |:------------|:-------------------------------------------------------------------------------|
      | Origin/Name | [prompt:Origin/Name]                                                           |
      | Brew method | [list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other] |
      | Brewer      | [prompt:Who brewed it?]                                                        |
      | Rating      | [list:Rating|★☆☆|★★☆|★★★]                                                      |
      | Notes       | [prompt:Notes]                                                                 |

      """
  ,
    test: """
      code|描述|详细解释
      :-|:-|:-
      200|成功|成功
      400|错误请求|该请求是无效的，详细的错误信息会说明原因
      401|验证错误|验证失败，详细的错误信息会说明原因
      403|被拒绝|被拒绝调用，详细的错误信息会说明原因
      404|无法找到|资源不存在
      429|过多的请求|超出了调用频率限制，详细的错误信息会说明原因
      500|内部服务错误|服务器内部出错了，请联系我们尽快解决问题
      504|内部服务响应超时|服务器在运行，本次请求响应超时,请稍后重试

      """
    expected: """
      | code | 描述             | 详细解释                                     |
      |:-----|:-----------------|:---------------------------------------------|
      | 200  | 成功             | 成功                                         |
      | 400  | 错误请求         | 该请求是无效的，详细的错误信息会说明原因     |
      | 401  | 验证错误         | 验证失败，详细的错误信息会说明原因           |
      | 403  | 被拒绝           | 被拒绝调用，详细的错误信息会说明原因         |
      | 404  | 无法找到         | 资源不存在                                   |
      | 429  | 过多的请求       | 超出了调用频率限制，详细的错误信息会说明原因 |
      | 500  | 内部服务错误     | 服务器内部出错了，请联系我们尽快解决问题     |
      | 504  | 内部服务响应超时 | 服务器在运行，本次请求响应超时,请稍后重试    |

      """
  ,
    test: """
      заголовок|таблицы
      -|-
      тело|таблицы
      продолжение|тела

      """
    expected: """
      | заголовок   | таблицы |
      |:------------|:--------|
      | тело        | таблицы |
      | продолжение | тела    |

      """
  ,
    # regression test for #16
    test: """
      | test | table | with| many | columns |
      |-|-|-|-|-
      |asd
      |dsa

      """
    expected: """
      | test | table | with | many | columns |
      |:-----|:------|:-----|:-----|:--------|
      | asd  |       |      |      |         |
      | dsa  |       |      |      |         |

      """
  ,
    # regression test for #17
    test: """
      | **Name**        | **Unicode**                           | **Unicode Name**                                      | **ASCII Dec**  |
      |:----------------|:--------------------------------------|:------------------------------------------------------|:---------------|
      | Digits          | The code points U+0030 through U+0039 | DIGIT ZERO through DIGIT NINE                         | 48 through 57  |
      | CA­PI­TAL-LETTERS | The code points U+0041 through U+005A | LATIN CA­PI­TAL LET­TER A through LATIN CA­PI­TAL LET­TER Z | 65 through 90  |
      | SMALL-LETTERS   | The code points U+0061 through U+007A | LATIN SMALL LET­TER A through LATIN SMALL LET­TER Z     | 97 through 122 |

      """
    expected: """
      | **Name**        | **Unicode**                           | **Unicode Name**                                      | **ASCII Dec**  |
      |:----------------|:--------------------------------------|:------------------------------------------------------|:---------------|
      | Digits          | The code points U+0030 through U+0039 | DIGIT ZERO through DIGIT NINE                         | 48 through 57  |
      | CA­PI­TAL-LETTERS | The code points U+0041 through U+005A | LATIN CA­PI­TAL LET­TER A through LATIN CA­PI­TAL LET­TER Z | 65 through 90  |
      | SMALL-LETTERS   | The code points U+0061 through U+007A | LATIN SMALL LET­TER A through LATIN SMALL LET­TER Z     | 97 through 122 |

      """
  ]
  testTablesDefaultLeft = [
      test: """
        |First Header|Second Header|
        |-|-|
        |Content|Content|
        |Content|Content|

        """
      expected: """
        | First Header | Second Header |
        |:-------------|:--------------|
        | Content      | Content       |
        | Content      | Content       |

        """
  ]
  testTablesDefaultCenter = [
      test: """
        |First Header|Second Header|
        |-|-|
        |Content|Content|
        |Content|Content|

        """
      expected: """
        | First Header | Second Header |
        |:------------:|:-------------:|
        |   Content    |    Content    |
        |   Content    |    Content    |

        """
  ]
  testTablesDefaultRight = [
      test: """
        |First Header|Second Header|
        |-|-|
        |Content|Content|
        |Content|Content|

        """
      expected: """
        | First Header | Second Header |
        |-------------:|--------------:|
        |      Content |       Content |
        |      Content |       Content |

        """
  ]
  nonTables = [
    """
    aaa|dafdas|adfas
    ----\\t| ----\\t| ---
    asdf|asadf|sdfas

    """

    """
    Here’s the original Coffee Log after decoding:
    dayone://post?entry=#coffee #log
    If you wish, you can add a leading and tailing pipe to each line of the table.
    Use the form that you like. As an illustration, this will give the same result as above:
    Note: A table need at least one pipe on each line for Markdown Extra to parse
    it correctly. This means that the only way to create a one-column table is to
    add a leading or a tailing pipe, or both of them, to each line.
    The align HTML attribute is applied to each cell of the concerned column.
    You can apply span-level formatting to the content of each cell using regular
    Markdown syntax:
    First, let’s talk about what Markdown tables look like. The full explanation
    can be found at either the PHP Markdown Extra or MultiMarkdown sites, but the
    nutshell version is this:
    The pipe (|) characters separate the columns. The alignment of each column is
    determined by the placement of the colons in the separator line. A colon at the
    left end only (or no colon at all) means left aligned; a colon at the right end
    only means right aligned; a colon at each end means centered.
    It’s nice to have the text version of the table spaced as I have it above with
    the pipes stacked on top of one another and the text aligned the way the separator
    line says. It’s very time consuming to type it in that way, though, so my tables
    tend to look more like this:
    which is easy to type, but hard to read and edit. So the first command I made
    is a Python script that takes an ugly text table and makes it pretty. Here’s the code.
    """

    """
     1  #!/usr/bin/python
     2
     3  import sys
     4
     5  def just(string, type, n):
     6      "Justify a string to length n according to type."
     7
     8      if type == '::':
     9          return string.center(n)
    10      elif type == '-:':
    11          return string.rjust(n)
    12      elif type == ':-':
    13          return string.ljust(n)
    14      else:
    15          return string
    16
    17
    18  def normtable(text):
    19      "Aligns the vertical bars in a text table."
    20
    21      # Start by turning the text into a list of lines.
    22      lines = text.splitlines()
    23      rows = len(lines)
    24
    25      # Figure out the cell formatting.
    26      # First, find the separator line.
    27      for i in range(rows):
    28          if set(lines[i]).issubset('|:.-'):
    29              formatline = lines[i]
    30              formatrow = i
    31              break
    32
    33      # Delete the separator line from the content.
    34      del lines[formatrow]
    35
    36      # Determine how each column is to be justified.
    37      formatline = formatline.strip('| ')
    38      fstrings = formatline.split('|')
    39      justify = []
    40      for cell in fstrings:
    41          ends = cell[0] + cell[-1]
    42          if ends == '::':
    43              justify.append('::')
    44          elif ends == '-:':
    45              justify.append('-:')
    46          else:
    47              justify.append(':-')
    48
    49      # Assume the number of columns in the separator line is the number
    50      # for the entire table.
    51      columns = len(justify)
    52
    53      # Extract the content into a matrix.
    54      content = []
    55      for line in lines:
    56          line = line.strip('| ')
    57          cells = line.split('|')
    58          # Put exactly one space at each end as "bumpers."
    59          linecontent = [ ' ' + x.strip() + ' ' for x in cells ]
    60          content.append(linecontent)
    61
    62      # Append cells to rows that don't have enough.
    63      rows = len(content)
    64      for i in range(rows):
    65          while len(content[i]) < columns:
    66              content[i].append('')
    67
    68      # Get the width of the content in each column. The minimum width will
    69      # be 2, because that's the shortest length of a formatting string and
    70      # because that matches an empty column with "bumper" spaces.
    71      widths = [2] * columns
    72      for row in content:
    73          for i in range(columns):
    74              widths[i] = max(len(row[i]), widths[i])
    75
    76      # Add whitespace to make all the columns the same width and
    77      formatted = []
    78      for row in content:
    79          formatted.append('|' + '|'.join([ just(s, t, n) for (s, t, n) in zip(row, justify, widths) ]) + '|')
    80
    81      # Recreate the format line with the appropriate column widths.
    82      formatline = '|' + '|'.join([ s[0] + '-'*(n-2) + s[-1] for (s, n) in zip(justify, widths) ]) + '|'
    83
    84      # Insert the formatline back into the table.
    85      formatted.insert(formatrow, formatline)
    86
    87      # Return the formatted table.
    88      return '\n'.join(formatted)
    89
    90
    91  # Read the input, process, and print.
    92  unformatted = sys.stdin.read()
    93  print normtable(unformatted)
    """
    ]
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('markdown-table-formatter')

  it "should load correctly", ->
    expect(MarkdownTableFormatter).toBeDefined()
    expect(MarkdownTableFormatter.tableFormatter).toBeDefined()

  it "should match the regex", ->
    for table in testTables
      expect(table.test).toMatch(MarkdownTableFormatter.tableFormatter.regex)

  it "should NOT match the regex", ->
    for table in nonTables
      expect(table).not.toMatch(MarkdownTableFormatter.tableFormatter.regex)

  it "should properly format this table", ->
    MarkdownTableFormatter.tableFormatter.spacePadding = 1
    MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
    rx = MarkdownTableFormatter.tableFormatter.regex
    for table in testTables
      rx.lastIndex = 0
      rxtable = rx.exec(table.test)
      formatted = MarkdownTableFormatter.tableFormatter.formatTable rxtable
      expect(formatted).toEqual(table.expected)

  it "should properly format this table", ->
    MarkdownTableFormatter.tableFormatter.spacePadding = 1
    MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
    MarkdownTableFormatter.tableFormatter.defaultTableJustification = 'Left'
    rx = MarkdownTableFormatter.tableFormatter.regex
    for table in testTablesDefaultLeft
      rx.lastIndex = 0
      rxtable = rx.exec(table.test)
      formatted = MarkdownTableFormatter.tableFormatter.formatTable rxtable
      expect(formatted).toEqual(table.expected)

  it "should properly format this table", ->
    MarkdownTableFormatter.tableFormatter.spacePadding = 1
    MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
    MarkdownTableFormatter.tableFormatter.defaultTableJustification = 'Center'
    rx = MarkdownTableFormatter.tableFormatter.regex
    for table in testTablesDefaultCenter
      rx.lastIndex = 0
      rxtable = rx.exec(table.test)
      formatted = MarkdownTableFormatter.tableFormatter.formatTable rxtable
      expect(formatted).toEqual(table.expected)

  it "should properly format this table", ->
    MarkdownTableFormatter.tableFormatter.spacePadding = 1
    MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
    MarkdownTableFormatter.tableFormatter.defaultTableJustification = 'Right'
    rx = MarkdownTableFormatter.tableFormatter.regex
    for table in testTablesDefaultRight
      rx.lastIndex = 0
      rxtable = rx.exec(table.test)
      formatted = MarkdownTableFormatter.tableFormatter.formatTable rxtable
      expect(formatted).toEqual(table.expected)

  it "should properly work with editor", ->
    editor = atom.workspace.buildTextEditor()
    editor.getGrammar().scopeName = 'source.gfm'
    expected = ""
    for table in testTables
      text = nonTables[Math.floor(Math.random() * nonTables.length)]
      editor.setText(editor.getText() + "\n" + text + "\n" + table.test)
      expected += "\n" + text + "\n" + table.expected
    MarkdownTableFormatter.tableFormatter.spacePadding = 1
    MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
    MarkdownTableFormatter.tableFormatter.autoSelectEntireDocument = true
    MarkdownTableFormatter.tableFormatter.formatOnSave = false
    MarkdownTableFormatter.tableFormatter.format editor
    expect(editor.getText()).toEqual(expected)
