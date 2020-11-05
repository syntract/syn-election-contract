require("dotenv").config();
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledSynElection = require('./build/SynElection.json');

const candidates = ["Candidate1", "Candidate2", "Candidate3", "Candidate4"];

const provider = new HDWalletProvider(
  process.env.MNEMONIC,
  process.env.PROVIDER_URL
);
const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attepmting to deploy from account', accounts[0]);
  console.log(compiledSynElection.interface);

  const hexCandidates = candidates.map(item => web3.utils.asciiToHex(item))
  const result = await new web3.eth.Contract(JSON.parse(compiledSynElection.interface))
     .deploy({data: compiledSynElection.bytecode, arguments: [hexCandidates] })
     .send({gas: '1000000', from: accounts[0]});

  console.log('Contract deployed to', result.options.address);

};
deploy();
