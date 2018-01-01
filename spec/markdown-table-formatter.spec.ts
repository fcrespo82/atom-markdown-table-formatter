import { expect } from 'chai'
import { loadPackage } from './utils'

describe('package', function() {
  it('should activate', async () => {
    await loadPackage()
    expect(atom.packages.isPackageActive('markdown-table-formatter')).to.equal(
      true,
    )
  })
})
