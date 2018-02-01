import { expect } from 'chai'
import nonTables = require('./tables/non-tables')
import { regex } from '../src/regex'
import { loadFixture } from './utils'

const testTables = loadFixture('test-tables')

describe('regex tests', function() {
  it('should match the regex', function() {
    for (const table of testTables) {
      table.input.match(regex)
      expect(table.input).to.match(regex)
    }
  })

  it('should NOT match the regex', function() {
    for (const table of nonTables) {
      table.match(regex)
      expect(table).not.to.match(regex)
    }
  })
})
