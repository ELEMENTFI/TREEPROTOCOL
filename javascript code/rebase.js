const Tx   =  require('ethereumjs-tx').Transaction
const { Contract } = require('ethers')
const Web3 = require('web3')
const web3 = new Web3('https://rinkeby.infura.io/v3/YOUR_INFURA_ID') //your infura id

const account1 = '0x759545eCa708D8e9D6f0D57acc80A9F7DFAD33ca' // Your account address 1
const account2 = '0xDFA17787B21a674df054fAa9A62d1f4a1B411902' // Your account address 2
var contractAddress = "0x724833dAAE1871279b15072216f1710ccb049786"; //Your implementation address
const abiArray = [
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "destination",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "bytes",
        "name": "data",
        "type": "bytes"
      }
    ],
    "name": "TransactionFailed",
    "type": "event"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "destination",
        "type": "address"
      },
      {
        "internalType": "bytes",
        "name": "data",
        "type": "bytes"
      }
    ],
    "name": "addTransaction",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "policy_",
        "type": "address"
      }
    ],
    "name": "initialize",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "policy",
    "outputs": [
      {
        "internalType": "contract eBNBPolicy",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "rebase",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "removeTransaction",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      },
      {
        "internalType": "bool",
        "name": "enabled",
        "type": "bool"
      }
    ],
    "name": "setTransactionEnabled",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "transactions",
    "outputs": [
      {
        "internalType": "bool",
        "name": "enabled",
        "type": "bool"
      },
      {
        "internalType": "address",
        "name": "destination",
        "type": "address"
      },
      {
        "internalType": "bytes",
        "name": "data",
        "type": "bytes"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "transactionsSize",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
const privateKey1 = Buffer.from(process.env.PRIVATE_KEY_1,'hex')
const privateKey2 = Buffer.from(process.env.PRIVATE_KEY_2,'hex')
const contract = new web3.eth.Contract(abiArray,contractAddress)
const Rebase = contract.methods.rebase().encodeABI()
web3.eth.getBalance(account1 ,(err,bal)=>{console.log(web3.utils.fromWei(bal,"ether"))})//we print the balance of our account
//this function calls by 1 min interval
function rebase(){
web3.eth.getTransactionCount(account1, (err,txCount) => {
  console.log("transaction so far",txCount)
    const txObject = {      
    nonce:    web3.utils.toHex(txCount),
    to:       contractAddress,
    gasLimit: web3.utils.toHex(800000),
    gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gwei')),
    data :Rebase
    
  }
  const tx =new Tx(txObject, {chain: 'rinkeby'})
  tx.sign(privateKey1)
  const serializedTx = tx.serialize()
  const raw = '0x' + serializedTx.toString('hex')
  web3.eth.sendSignedTransaction(raw, (err, txHash) => {
    console.log('txHash:', txHash)
  })
 

console.log(txObject)
})
web3.eth.getBalance(account1 ,(err,bal)=>{console.log(web3.utils.fromWei(bal,"ether"))})//Here we get the balance of our account after rebase

}
setInterval(rebase,60000)  //rebase now set to 1 min but we want to set 24 hours
