module.exports =
  [
    '''
    aaa|dafdas|adfas
    ----\\t| ----\\t| ---
    asdf|asadf|sdfas

    '''

    '''
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
    '''

    '''
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
    '''
  ]
