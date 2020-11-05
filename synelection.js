require("dotenv").config();
import web3 from "./web3";
import SynElection from "./build/SynElection.json";

const instance = new web3.eth.Contract(
  JSON.parse(SynElection.interface),
  process.env.CONTRACT_ADDRESS
);

export default instance;
