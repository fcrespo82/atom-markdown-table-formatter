import { loadFixture } from './utils'
import { expect } from 'chai'

describe('Duplicate tests', () => {
  function test(name: string) {
    it(`do not exist on ${name}`, () => {
      const res = loadFixture(name)
      res.forEach((x, i) => {
        expect(res.findIndex(y => y.input === x.input)).to.be.equal(
          i,
          `duplicate test in ${name}[${i}]: "${x.input}"`,
        )
      })
    })
  }
  test('test-tables')
  test('test-tables-pref-line-len')
})
