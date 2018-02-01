export {}
declare module 'atom' {
  interface ConfigValues {
    'markdown-table-formatter': {
      autoSelectEntireDocument: boolean
      spacePadding: number
      keepFirstAndLastPipes: boolean
      formatOnSave: boolean
      defaultTableJustification: 'Left' | 'Right' | 'Center'
      markdownGrammarScopes: string[]
      limitLastColumnPadding: boolean
    }
    'markdown-table-formatter.autoSelectEntireDocument': boolean
    'markdown-table-formatter.spacePadding': number
    'markdown-table-formatter.keepFirstAndLastPipes': boolean
    'markdown-table-formatter.formatOnSave': boolean
    'markdown-table-formatter.defaultTableJustification':
      | 'Left'
      | 'Right'
      | 'Center'
    'markdown-table-formatter.markdownGrammarScopes': string[]
    'markdown-table-formatter.limitLastColumnPadding': boolean
  }
  interface Config {
    get<T extends keyof ConfigValues>(
      keyPath: T,
      options?: {
        sources?: string[]
        excludeSources?: string[]
        scope?: string[] | ScopeDescriptor
      },
    ): ConfigValues[T]
  }
}
