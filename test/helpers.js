export const wait = seconds => {
  const milliseconds = seconds * 1000

  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

export const EVM_REVERT = 'VM Exception while processing transaction: revert'
