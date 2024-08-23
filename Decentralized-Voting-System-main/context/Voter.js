
import React, {useState,useEffect} from 'react';
import Web3Modal from "web3modal";
import { ethers, Signer } from "ethers";
import { create } from 'ipfs-core';
import axios from "axios";
import { useRouter } from "next/router";

// Internal imports
import { VotingAddress, VotingAddressABI } from "./constants";

const client = create({
    host: 'ipfs.infura.io',
    port: 5001,
    protocol: 'https',
  });
const fetchContract = (signerOrProvider) => new ethers.Contract(VotingAddress, VotingAddressABI, signerOrProvider);

export const VotingContext = React.createContext();
export const VotingProvider = ({children}) => {
    const votingTitle = "My first smart Contract app"
    const router = useRouter();
    const [currentAccount, setCurrentAccount] = useState('');
    const [candidateLength, setCandidateLength] = useState('');
    const pushCandidate = [];
    const candidateIndex =[];
    const [candidateArray, setcandidateArray] = useState(pushCandidate);

    // End of Candidate Data

    const [error, setError] =  useState('');
    const  highestVote = [];

    //  Voter Section
    const [voterArray, setVoterArray] = useState(pushVoter);
    const [voterLength, setVoterLength] = useState('');
    const [voterAddress, setvoterAddress] = useState([]);

    // Connecting Metamask

    const checkIfWalletIsConnected = async()=>{
        if (!window.ethereum) return setError ("Please Install MetaMask")
    };

    return (
        <VotingContext.Provider value={{votingTitle}}>
            {children}
        </VotingContext.Provider>
    );
};



