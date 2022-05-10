import React, { Component } from "react";
import LotteryContract from "./contracts/Lottery.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { manager: 0, players: 0, prize: 0, winner: 0,
    web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = LotteryContract.networks[networkId];
      const instance = new web3.eth.Contract(
        LotteryContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { contract, web3 } = this.state;

    // Get values from contract
    const manager = await contract.methods.manager().call();
    const players = await contract.methods.getPlayers().call();
    const winner = await contract.methods.winner().call();
    const prize = await web3.eth.getBalance(contract.opitons.address);

    // update state
    this.setState({ manager: manager, players: players, winner: winner, 
        prize: web3.utils.fromWei(prize, "ether")});
  };

  render() {
    return (
      <div className="App">
        <h2>May the offs be ever in your favor!</h2>
        <p className="Board">
          This content is managed by address {this.state.manager}.
          There are currently {this.state.players} people entered, 
          competing to win {this.state.prize} ethers!
          <br />
          <br />
          {this.state.winner} has won the last lottery. 
        </p>
        <h2>Want to try your odd?</h2>
        <p className="Enter">
          <button onClick={this.handleEnter}> Buy one ticket </button>
          <br />
          {this.state.transactionHash}
        </p>
      </div>
    );
  }
}

handleEnter = async () => {
  const {contract, accounts} = this.state;
  const enter = await contract.methods.enter().send({from: accounts[1], value: '100000000000000000'});
  this.setState({ transactionHash: enter.transactionHash});
}

export default App;
