import { formatTable } from '../src/formatTable'
import { testFormat, testSuite, loadPackage } from './utils'
import { regex } from '../src/regex'

describe('format tests', function() {
  beforeEach(async () => {
    await loadPackage()
  })

  const test = testFormat(function(input: string) {
    regex.lastIndex = 0
    const r = regex.exec(input)
    if (r) return formatTable(r)
    else return 'No regex match'
  })

  describe('default options', function() {
    beforeEach(function() {
      atom.config.set('markdown-table-formatter.spacePadding', 1)
      atom.config.set('markdown-table-formatter.keepFirstAndLastPipes', true)
      atom.config.set(
        'markdown-table-formatter.defaultTableJustification',
        'Left',
      )
    })

    testSuite(test)
  })
})
