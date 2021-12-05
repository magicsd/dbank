const Token = artifacts.require('Token')
// const dBank = artifacts.require('dBank')

module.exports = async deployer => {
  await deployer.deploy(Token)
}
