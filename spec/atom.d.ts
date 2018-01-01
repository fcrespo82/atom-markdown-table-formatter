export {}
declare module 'atom' {
  interface TextBuffer {
    setPreferredLineEnding(e: string): void
  }
}
