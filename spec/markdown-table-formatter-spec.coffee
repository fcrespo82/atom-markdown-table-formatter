{TextEditor} = require 'atom'
MarkdownTableFormatter = require '../lib/markdown-table-formatter'

describe "When formatting a table", ->
  testTables=[
    test:
      "|Left|Center|Right|\n"+
      "|:-|:-:|-:|\n"+
      "|1|2|3|\n"
    expected:
      "| Left | Center | Right |\n"+
      "|:-----|:------:|------:|\n"+
      "| 1    |   2    |     3 |\n"
  ,
    test:
      "| h1 h1| h2 | h3 |\n"+
      "|-|-|-|\n"+
      "| data1 | data2 | data3 |\n"
    expected:
      "| h1 h1 | h2    | h3    |\n"+
      "|:------|:------|:------|\n"+
      "| data1 | data2 | data3 |\n"
  ,
    test:
      "h1 | h2 | h3\n"+
      "-|-|-\n"+
      "data-1 | data-2 | data-3\n"
    expected:
      "| h1     | h2     | h3     |\n"+
      "|:-------|:-------|:-------|\n"+
      "| data-1 | data-2 | data-3 |\n"
  ,
    test:
      "-|-|-\n"+
      "a|b|c\n"
    expected:
      "|:--|:--|:--|\n"+
      "| a | b | c |\n"
  ,
    test:
      "| Header 1 | Header 2 | Header 3 |\n"+
      "|----|---|-|\n"+
      "| data1a | Data is longer than header | 1 |\n"+
      "| d1b | add a cell|\n"+
      "|lorem|ipsum|3|\n"+
      "| | empty outside cells\n"+
      "| skip| | 5 |\n"+
      "| six | Morbi purus | 6 |      \n"
    expected:
      "| Header 1 | Header 2                   | Header 3 |\n"+
      "|:---------|:---------------------------|:---------|\n"+
      "| data1a   | Data is longer than header | 1        |\n"+
      "| d1b      | add a cell                 |          |\n"+
      "| lorem    | ipsum                      | 3        |\n"+
      "|          | empty outside cells        |          |\n"+
      "| skip     |                            | 5        |\n"+
      "| six      | Morbi purus                | 6        |\n"
  ,
    test:
      "|teste-3|\n"+
      "|---|\n"+
      "|other|\n"
    expected:
      "| teste-3 |\n"+
      "|:--------|\n"+
      "| other   |\n"
  ,
    test:
      "|outro \n"+
      "|- \n"+
      "|teste \n"
    expected:
      "| outro |\n"+
      "|:------|\n"+
      "| teste |\n"
  ,
    test:
      "outro|\n"+
      ":-:|\n"+
      "teste|\n"
    expected:
      "| outro |\n"+
      "|:-----:|\n"+
      "| teste |\n"
  ,
    test:
      "First Header  | Second Header\n"+
      "------------- | -------------\n"+
      "Content Cell  | Content Cell\n"+
      "Content Cell  | Content Cell\n"
    expected:
      "| First Header | Second Header |\n"+
      "|:-------------|:--------------|\n"+
      "| Content Cell | Content Cell  |\n"+
      "| Content Cell | Content Cell  |\n"
  ,
    test:
      "| First Header  | Second Header |\n"+
      "| ------------- | ------------- |\n"+
      "| Content Cell  | Content Cell  |\n"+
      "| Content Cell  | Content Cell  |\n"
    expected:
      "| First Header | Second Header |\n"+
      "|:-------------|:--------------|\n"+
      "| Content Cell | Content Cell  |\n"+
      "| Content Cell | Content Cell  |\n"
  ,
    test:
      "| First Header  | Second Header |\n"+
      "| ------------- | ------------- |\n"+
      "| Content Cell  | Content Cell  |\n"+
      "| Content Cell  | Content Cell  |\n"
    expected:
      "| First Header | Second Header |\n"+
      "|:-------------|:--------------|\n"+
      "| Content Cell | Content Cell  |\n"+
      "| Content Cell | Content Cell  |\n"
  ,
    test:
      "| Item      | Value |\n"+
      "| --------- | -----:|\n"+
      "| Computer  | $1600 |\n"+
      "| Phone     |   $12 |\n"+
      "| Pipe      |    $1 |\n"
    expected:
      "| Item     | Value |\n"+
      "|:---------|------:|\n"+
      "| Computer | $1600 |\n"+
      "| Phone    |   $12 |\n"+
      "| Pipe     |    $1 |\n"
  ,
    test:
      "| Function name | Description                    |\n"+
      "| ------------- | ------------------------------ |\n"+
      "| `help()`      | Display the help window.       |\n"+
      "| `destroy()`   | **Destroy your computer!**     |\n"
    expected:
      "| Function name | Description                |\n"+
      "|:--------------|:---------------------------|\n"+
      "| `help()`      | Display the help window.   |\n"+
      "| `destroy()`   | **Destroy your computer!** |\n"
  ,
    test:
      "| Left align | Right align | Center align |\n"+
      "|:-----------|------------:|:------------:|\n"+
      "| This       |        This |     This     |\n"+
      "| column     |      column |    column    |\n"+
      "| will       |        will |     will     |\n"+
      "| be         |          be |      be      |\n"+
      "| left       |       right |    center    |\n"+
      "| aligned    |     aligned |   aligned    |\n"
    expected:
      "| Left align | Right align | Center align |\n"+
      "|:-----------|------------:|:------------:|\n"+
      "| This       |        This |     This     |\n"+
      "| column     |      column |    column    |\n"+
      "| will       |        will |     will     |\n"+
      "| be         |          be |      be      |\n"+
      "| left       |       right |    center    |\n"+
      "| aligned    |     aligned |   aligned    |\n"
  ,
    test:
      "|Left align|Right align|Center align|\n"+
      "|:---------|----------:|:----------:|\n"+
      "|This|This|This|\n"+
      "|column|column|column|\n"+
      "|will|will|will|\n"+
      "|be|be|be|\n"+
      "|left|right|center|\n"+
      "|aligned|aligned|aligned|\n"
    expected:
      "| Left align | Right align | Center align |\n"+
      "|:-----------|------------:|:------------:|\n"+
      "| This       |        This |     This     |\n"+
      "| column     |      column |    column    |\n"+
      "| will       |        will |     will     |\n"+
      "| be         |          be |      be      |\n"+
      "| left       |       right |    center    |\n"+
      "| aligned    |     aligned |   aligned    |\n"
  ,
    test:
      "First Header  | Second Header\n"+
      "------------- | -------------\n"+
      "Content Cell  | Content Cell\n"+
      "Content Cell  | Content Cell\n"
    expected:
      "| First Header | Second Header |\n"+
      "|:-------------|:--------------|\n"+
      "| Content Cell | Content Cell  |\n"+
      "| Content Cell | Content Cell  |\n"
  ,
    test:
      "First Header  | Second Header\n"+
      "------------- | -------------\n"+
      "Content Cell  | Content Cell\n"+
      "Content Cell  | Content Cell\n"
    expected:
      "| First Header | Second Header |\n"+
      "|:-------------|:--------------|\n"+
      "| Content Cell | Content Cell  |\n"+
      "| Content Cell | Content Cell  |\n"
  ,
    test:
      "| First Header  | Second Header |\n"+
      "| ------------- | ------------- |\n"+
      "| Content Cell  | Content Cell  |\n"+
      "| Content Cell  | Content Cell  |\n"
    expected:
      "| First Header | Second Header |\n"+
      "|:-------------|:--------------|\n"+
      "| Content Cell | Content Cell  |\n"+
      "| Content Cell | Content Cell  |\n"
  ,
    test:
      "| Name | Description          |\n"+
      "| ------------- | ----------- |\n"+
      "| Help      | Display the help window.|\n"+
      "| Close     | Closes a window     |\n"
    expected:
      "| Name  | Description              |\n"+
      "|:------|:-------------------------|\n"+
      "| Help  | Display the help window. |\n"+
      "| Close | Closes a window          |\n"
  ,
    test:
      "| Name | Description          |\n"+
      "| ------------- | ----------- |\n"+
      "| Help      | ~~Display the~~ help window.|\n"+
      "| Close     | _Closes_ a window     |\n"
    expected:
      "| Name  | Description                  |\n"+
      "|:------|:-----------------------------|\n"+
      "| Help  | ~~Display the~~ help window. |\n"+
      "| Close | _Closes_ a window            |\n"
  ,
    test:
      "| Left-Aligned  | Center Aligned  | Right Aligned |\n"+
      "| :------------ |:---------------:| -----:|\n"+
      "| col 3 is      | some wordy text | $1600 |\n"+
      "| col 2 is      | centered        |   $12 |\n"+
      "| zebra stripes | are neat        |    $1 |\n"
    expected:
      "| Left-Aligned  | Center Aligned  | Right Aligned |\n"+
      "|:--------------|:---------------:|--------------:|\n"+
      "| col 3 is      | some wordy text |         $1600 |\n"+
      "| col 2 is      |    centered     |           $12 |\n"+
      "| zebra stripes |    are neat     |            $1 |\n"
  ,
    test:
      "| First Header | Second Header |         Third Header |  \n"+
      "| :----------- | :-----------: | -------------------: |  \n"+
      "| First row    |      Data     | Very long data entry |  \n"+
      "| Second row   |    **Cell**   |               *Cell* |  \n"
    expected:
      "| First Header | Second Header |         Third Header |\n"+
      "|:-------------|:-------------:|---------------------:|\n"+
      "| First row    |     Data      | Very long data entry |\n"+
      "| Second row   |   **Cell**    |               *Cell* |\n"
  ,
    test:
      "|Coffee||\n"+
      "|:---|:---|\n"+
      "|Origin/Name|[prompt:Origin/Name]|\n"+
      "|Brew method|[list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other]|\n"+
      "|Brewer|[prompt:Who brewed it?]|\n"+
      "|Rating|[list:Rating|★☆☆|★★☆|★★★]|\n"+
      "|Notes|[prompt:Notes]|\n"
    expected:
      "| Coffee      |                                                                                |\n"+
      "|:------------|:-------------------------------------------------------------------------------|\n"+
      "| Origin/Name | [prompt:Origin/Name]                                                           |\n"+
      "| Brew method | [list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other] |\n"+
      "| Brewer      | [prompt:Who brewed it?]                                                        |\n"+
      "| Rating      | [list:Rating|★☆☆|★★☆|★★★]                                                      |\n"+
      "| Notes       | [prompt:Notes]                                                                 |\n"
  ,
    test:
      "code | 描述             | 详细解释\n"+
      ":-----|:-----------------|:---------------------------------------------\n"+
      " 200  | 成功             | 成功\n"+
      " 400  | 错误请求         | 该请求是无效的，详细的错误信息会说明原因\n"+
      " 401  | 验证错误         | 验证失败，详细的错误信息会说明原因\n"+
      " 403  | 被拒绝           | 被拒绝调用，详细的错误信息会说明原因\n"+
      " 404  | 无法找到       | 资源不存在\n"+
      " 429  | 过多的请求     | 超出了调用频率限制，详细的错误信息会说明原因\n"+
      " 500  | 内部服务错误     | 服务器内部出错了，请联系我们尽快解决问题\n"+
      " 504  | 内部服务响应超时 | 服务器在运行，本次请求响应超时,请稍后重试\n"
    expected:
      "| code | 描述             | 详细解释                                     |\n"+
      "|:-----|:-----------------|:---------------------------------------------|\n"+
      "| 200  | 成功             | 成功                                         |\n"+
      "| 400  | 错误请求         | 该请求是无效的，详细的错误信息会说明原因     |\n"+
      "| 401  | 验证错误         | 验证失败，详细的错误信息会说明原因           |\n"+
      "| 403  | 被拒绝           | 被拒绝调用，详细的错误信息会说明原因         |\n"+
      "| 404  | 无法找到         | 资源不存在                                   |\n"+
      "| 429  | 过多的请求       | 超出了调用频率限制，详细的错误信息会说明原因 |\n"+
      "| 500  | 内部服务错误     | 服务器内部出错了，请联系我们尽快解决问题     |\n"+
      "| 504  | 内部服务响应超时 | 服务器在运行，本次请求响应超时,请稍后重试    |\n"
  ,
    test:
      "заголовок|таблицы\n
      -|-\n
      тело|таблицы\n
      продолжение|тела\n
      "
    expected:
      "| заголовок   | таблицы |\n"+
      "|:------------|:--------|\n"+
      "| тело        | таблицы |\n"+
      "| продолжение | тела    |\n"
  ,
    # regression test for #16
    test:
      "| test | table | with| many | columns |\n"+
      "|-|-|-|-|-\n"+
      "|asd\n"+
      "|dsa\n"
    expected:
      "| test | table | with | many | columns |\n"+
      "|:-----|:------|:-----|:-----|:--------|\n"+
      "| asd  |       |      |      |         |\n"+
      "| dsa  |       |      |      |         |\n"
  ,
    # regression test for #17
    test:
      """
      | **Name**        | **Unicode**                           | **Unicode Name**                                      | **ASCII Dec**  |
      |:----------------|:--------------------------------------|:------------------------------------------------------|:---------------|
      | Digits          | The code points U+0030 through U+0039 | DIGIT ZERO through DIGIT NINE                         | 48 through 57  |
      | CA­PI­TAL-LETTERS | The code points U+0041 through U+005A | LATIN CA­PI­TAL LET­TER A through LATIN CA­PI­TAL LET­TER Z | 65 through 90  |
      | SMALL-LETTERS   | The code points U+0061 through U+007A | LATIN SMALL LET­TER A through LATIN SMALL LET­TER Z     | 97 through 122 |
      """
    expected:
      """
      | **Name**        | **Unicode**                           | **Unicode Name**                                      | **ASCII Dec**  |
      |:----------------|:--------------------------------------|:------------------------------------------------------|:---------------|
      | Digits          | The code points U+0030 through U+0039 | DIGIT ZERO through DIGIT NINE                         | 48 through 57  |
      | CA­PI­TAL-LETTERS | The code points U+0041 through U+005A | LATIN CA­PI­TAL LET­TER A through LATIN CA­PI­TAL LET­TER Z | 65 through 90  |
      | SMALL-LETTERS   | The code points U+0061 through U+007A | LATIN SMALL LET­TER A through LATIN SMALL LET­TER Z     | 97 through 122 |

      """
  ]
  nonTables=[
    "aaa|dafdas|adfas\n"+
    "----\\t| ----\\t| ---\n"+
    "asdf|asadf|sdfas\n"

    "Here’s the original Coffee Log after decoding:\n"+
    "dayone://post?entry=#coffee #log\n"+
    "If you wish, you can add a leading and tailing pipe to each line of the table. Use the form that you like. As an illustration, this will give the same result as above:\n"+
    "Note: A table need at least one pipe on each line for Markdown Extra to parse it correctly. This means that the only way to create a one-column table is to add a leading or a tailing pipe, or both of them, to each line.\n"+
    "The align HTML attribute is applied to each cell of the concerned column.\n"+
    "You can apply span-level formatting to the content of each cell using regular Markdown syntax:\n"+
    "First, let’s talk about what Markdown tables look like. The full explanation can be found at either the PHP Markdown Extra or MultiMarkdown sites, but the nutshell version is this:\n"+
    "The pipe (|) characters separate the columns. The alignment of each column is determined by the placement of the colons in the separator line. A colon at the left end only (or no colon at all) means left aligned; a colon at the right end only means right aligned; a colon at each end means centered.\n"+
    "It’s nice to have the text version of the table spaced as I have it above with the pipes stacked on top of one another and the text aligned the way the separator line says. It’s very time consuming to type it in that way, though, so my tables tend to look more like this:\n"+
    "which is easy to type, but hard to read and edit. So the first command I made is a Python script that takes an ugly text table and makes it pretty. Here’s the code.\n"+

    " 1  #!/usr/bin/python\n"+
    " 2  \n"+
    " 3  import sys\n"+
    " 4  \n"+
    " 5  def just(string, type, n):\n"+
    " 6      \"Justify a string to length n according to type.\"\n"+
    " 7      \n"+
    " 8      if type == '::':\n"+
    " 9          return string.center(n)\n"+
    "10      elif type == '-:':\n"+
    "11          return string.rjust(n)\n"+
    "12      elif type == ':-':\n"+
    "13          return string.ljust(n)\n"+
    "14      else:\n"+
    "15          return string\n"+
    "16  \n"+
    "17  \n"+
    "18  def normtable(text):\n"+
    "19      \"Aligns the vertical bars in a text table.\"\n"+
    "20      \n"+
    "21      # Start by turning the text into a list of lines.\n"+
    "22      lines = text.splitlines()\n"+
    "23      rows = len(lines)\n"+
    "24      \n"+
    "25      # Figure out the cell formatting.\n"+
    "26      # First, find the separator line.\n"+
    "27      for i in range(rows):\n"+
    "28          if set(lines[i]).issubset('|:.-'):\n"+
    "29              formatline = lines[i]\n"+
    "30              formatrow = i\n"+
    "31              break\n"+
    "32      \n"+
    "33      # Delete the separator line from the content.\n"+
    "34      del lines[formatrow]\n"+
    "35      \n"+
    "36      # Determine how each column is to be justified. \n"+
    "37      formatline = formatline.strip('| ')\n"+
    "38      fstrings = formatline.split('|')\n"+
    "39      justify = []\n"+
    "40      for cell in fstrings:\n"+
    "41          ends = cell[0] + cell[-1]\n"+
    "42          if ends == '::':\n"+
    "43              justify.append('::')\n"+
    "44          elif ends == '-:':\n"+
    "45              justify.append('-:')\n"+
    "46          else:\n"+
    "47              justify.append(':-')\n"+
    "48      \n"+
    "49      # Assume the number of columns in the separator line is the number\n"+
    "50      # for the entire table.\n"+
    "51      columns = len(justify)\n"+
    "52      \n"+
    "53      # Extract the content into a matrix.\n"+
    "54      content = []\n"+
    "55      for line in lines:\n"+
    "56          line = line.strip('| ')\n"+
    "57          cells = line.split('|')\n"+
    "58          # Put exactly one space at each end as \"bumpers.\"\n"+
    "59          linecontent = [ ' ' + x.strip() + ' ' for x in cells ]\n"+
    "60          content.append(linecontent)\n"+
    "61      \n"+
    "62      # Append cells to rows that don't have enough.\n"+
    "63      rows = len(content)\n"+
    "64      for i in range(rows):\n"+
    "65          while len(content[i]) < columns:\n"+
    "66              content[i].append('')\n"+
    "67      \n"+
    "68      # Get the width of the content in each column. The minimum width will\n"+
    "69      # be 2, because that's the shortest length of a formatting string and\n"+
    "70      # because that matches an empty column with \"bumper\" spaces.\n"+
    "71      widths = [2] * columns\n"+
    "72      for row in content:\n"+
    "73          for i in range(columns):\n"+
    "74              widths[i] = max(len(row[i]), widths[i])\n"+
    "75      \n"+
    "76      # Add whitespace to make all the columns the same width and \n"+
    "77      formatted = []\n"+
    "78      for row in content:\n"+
    "79          formatted.append('|' + '|'.join([ just(s, t, n) for (s, t, n) in zip(row, justify, widths) ]) + '|')\n"+
    "80      \n"+
    "81      # Recreate the format line with the appropriate column widths.\n"+
    "82      formatline = '|' + '|'.join([ s[0] + '-'*(n-2) + s[-1] for (s, n) in zip(justify, widths) ]) + '|'\n"+
    "83      \n"+
    "84      # Insert the formatline back into the table.\n"+
    "85      formatted.insert(formatrow, formatline)\n"+
    "86      \n"+
    "87      # Return the formatted table.\n"+
    "88      return '\n'.join(formatted)\n"+
    "89  \n"+
    "90          \n"+
    "91  # Read the input, process, and print.\n"+
    "92  unformatted = sys.stdin.read()   \n"+
    "93  print normtable(unformatted)\n"
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
      formatted=MarkdownTableFormatter.tableFormatter.formatTable rxtable
      expect(formatted).toEqual(table.expected)

  it "should properly work with editor", ->
    editor=new TextEditor(atom.workspace)
    editor.getGrammar().scopeName='source.gfm'
    expected=""
    for table in testTables
      text = nonTables[Math.floor(Math.random()*nonTables.length)]
      editor.setText(editor.getText()+"\n"+text+"\n"+table.test)
      expected+="\n"+text+"\n"+table.expected
    MarkdownTableFormatter.tableFormatter.spacePadding = 1
    MarkdownTableFormatter.tableFormatter.keepFirstAndLastPipes = true
    MarkdownTableFormatter.tableFormatter.autoSelectEntireDocument = true
    MarkdownTableFormatter.tableFormatter.formatOnSave = false
    MarkdownTableFormatter.tableFormatter.format editor
    expect(editor.getText()).toEqual(expected)
