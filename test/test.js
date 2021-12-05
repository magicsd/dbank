const Token = artifacts.require('Token')
const dBank = artifacts.require('dBank')

const EVM_REVERT = 'VM Exception while processing transaction: revert'

require('chai').use(require('chai-as-promised')).should()

contract('dBank', ([deployer, user]) => {
  let dbank, token

  beforeEach(async () => {
    token = await Token.new()
    dbank = await dBank.new(token.address)
    await token.passMinterRole(dbank.address, { from: deployer })
  })

  describe('testing token contract...', () => {
    describe('success', () => {
      it('checking token name', async () => {
        expect(await token.name()).to.be.eq('Decentralized Bank Currency')
      })

      it('checking token symbol', async () => {
        expect(await token.symbol()).to.be.eq('DBC')
      })

      it('checking token initial total supply', async () => {
        expect(Number(await token.totalSupply())).to.eq(0)
      })

      it('dBank should have Token minter role', async () => {
        expect(await token.minter()).to.eq(dbank.address)
      })
    })

    describe('failure', () => {
      it('passing minter role should be rejected', async () => {
        await token.passMinterRole(user, { from: deployer }).should.be.rejectedWith(EVM_REVERT)
      })

      it('token minting should be rejected', async () => {
        await token.mint(user, '1', { from: deployer }).should.be.rejectedWith(EVM_REVERT)
      })
    })
  })

  describe('testing deposit...', () => {
    let balance
    const depositValue = 10 ** 16 // 0.01 ETH

    describe('success', () => {
      beforeEach(async () => {
        await dbank.deposit({ value: depositValue, from: user })
      })

      it('balance should increase', async () => {
        expect(Number(await dbank.etherBalanceOf(user))).to.eq(depositValue)
      })

      it('deposit time should be > 0', async () => {
        expect(Number(await dbank.depositStart(user))).to.be.above(0)
      })

      it('balance status should eq true', async () => {
        expect(await dbank.isDeposited(user)).to.eq(true)
      })
    })

    describe('failure', () => {
      it('depositing should be rejected', async () => {
        await dbank.deposit({ value: 10**15, from: user }).should.be.rejectedWith(EVM_REVERT)
      })

      it('depositing twice should be rejected', async () => {
        await dbank.deposit({ value: depositValue, from: user })
        await dbank.deposit({ value: depositValue, from: user }).should.be.rejectedWith(EVM_REVERT)
      })
    })
  })
})
