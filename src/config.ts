export const config = {
  formatOnSave: {
    type: 'boolean',
    default: true,
    description: 'Format tables when document is saved?',
  },
  autoSelectEntireDocument: {
    type: 'boolean',
    default: true,
    description: 'Select entire document if selection is empty',
  },
  spacePadding: {
    type: 'integer',
    default: 1,
    description:
      'How many spaces between left and right of each column content',
  },
  keepFirstAndLastPipes: {
    type: 'boolean',
    default: true,
    description: `Keep first and last pipes "|" in table formatting. \
Tables are easier to format when pipes are kept`,
  },
  defaultTableJustification: {
    type: 'string',
    default: 'Left',
    enum: ['Left', 'Center', 'Right'],
    description: `Defines the default justification for tables that have only a \
\'-\' on the formatting line`,
  },
  markdownGrammarScopes: {
    type: 'array',
    default: ['source.gfm'],
    description: `File grammar scopes that will be considered Markdown by this package (comma-separated). \
Run \'Markdown Table Formatter: Enable For Current Scope\' command to \
add current editor grammar to this setting.`,
    items: {
      type: 'string',
    },
  },
  limitLastColumnPadding: {
    type: 'boolean',
    default: false,
    description: `Do not pad the last column to more than your editor\'s \
preferredLineLength setting.`,
  },
}
