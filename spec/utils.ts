import { expect } from 'chai'
import testTablesDefault = require('./tables/test-tables-default')
import { join } from 'path'
import { readFileSync } from 'fs'

const pkg = join(__dirname, '..')
const testTables = loadFixture('test-tables')
const testTablesPrefLineLen = loadFixture('test-tables-pref-line-len')

export interface TestData {
  input: string
  expected: string
}

export function testFormat(
  formatter: (x: string) => string,
  modifier?: (x: string, rand: number) => string,
) {
  return function({ input, expected }: TestData) {
    if (modifier === undefined) {
      modifier = x => x
    }
    const rand = Math.random()
    expect(formatter(modifier(input, rand))).to.equal(modifier(expected, rand))
  }
}

function testSuiteSingle(test: (arg: TestData) => void, tbls: TestData[]) {
  it('should properly format these tables', () => tbls.forEach(test))
}

export function testSuite(test: (arg: TestData) => void) {
  testSuiteSingle(test, testTables)

  for (const just of Object.keys(testTablesDefault)) {
    const tbls = testTablesDefault[just]
    describe(`Default ${just} justification tests`, function() {
      beforeEach(() =>
        atom.config.set(
          'markdown-table-formatter.defaultTableJustification',
          just,
        ),
      )
      testSuiteSingle(test, tbls)
      afterEach(() => {
        atom.config.unset('markdown-table-formatter.defaultTableJustification')
      })
    })
  }

  describe('limitLastColumnPadding tests', function() {
    beforeEach(function() {
      atom.config.set('markdown-table-formatter.limitLastColumnPadding', true)
    })

    testSuiteSingle(test, testTablesPrefLineLen)

    afterEach(function() {
      atom.config.set('markdown-table-formatter.limitLastColumnPadding', false)
    })
  })
}

export async function loadPackage() {
  await atom.packages.activatePackage(pkg)
}

export function settings(name: string) {
  return atom.config.get(`markdown-table-formatter.${name}`)
}

export function loadFixture(name: string) {
  const fixture = join(__dirname, `fixtures/${name}.md`)
  const data = readFileSync(fixture, { encoding: 'utf8' })

  return data
    .split(/\n# Input*[^\n]*\n/g)
    .slice(1)
    .map(t => {
      const [input, expected] = t.split(/\n# Expected*[^\n]*\n/g)
      expect(input).to.exist
      expect(expected).to.exist
      return { input, expected }
    })
}
