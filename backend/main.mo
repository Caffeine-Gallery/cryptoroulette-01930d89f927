import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";

import Timer "mo:base/Timer";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor {
    stable var currentCryptos : [Text] = [];
    stable var lastUpdate : Time.Time = 0;

    // List of top 100 cryptocurrency IDs from CoinGecko
    let cryptoIds : [Text] = [
        "bitcoin", "ethereum", "tether", "binancecoin", "ripple", "usd-coin", "steth", 
        "cardano", "dogecoin", "solana", "tron", "polkadot", "matic-network", "litecoin",
        "wrapped-bitcoin", "dai", "chainlink", "shiba-inu", "bitcoin-cash", "avalanche-2",
        "stellar", "monero", "uniswap", "okb", "ethereum-classic", "cosmos", "hedera-hashgraph",
        "filecoin", "crypto-com-chain", "lido-dao", "internet-computer", "quant", "near",
        "vechain", "maker", "algorand", "graph", "flow", "frax", "elrond-erd-2",
        "theta-token", "fantom", "axie-infinity", "decentraland", "tezos", "aave",
        "the-sandbox", "eos", "trueusd", "theta-fuel", "kucoin-shares", "gatetoken",
        "neo", "iota", "usdd", "rocket-pool-eth", "apecoin", "paxos-standard", "huobi-token",
        "thorchain", "rocket-pool", "curve-dao-token", "kava", "zilliqa", "pancakeswap-token",
        "basic-attention-token", "gmx", "nexo", "dash", "zcash", "mina-protocol", 
        "synthetix-network-token", "compound-governance-token", "arweave", "1inch", "waves",
        "osmosis", "render-token", "trust-wallet-token", "gnosis", "xdce-crowd-sale",
        "loopring", "enjincoin", "decred", "golem", "siacoin", "stacks", "ankr",
        "livepeer", "wax", "polymath", "status", "civic", "storj", "nucypher",
        "numeraire", "orchid-protocol", "fetch-ai", "cartesi", "ocean-protocol", "band-protocol"
    ];

    // Update the current crypto selection
    private func updateCryptos() {
        let result = Buffer.Buffer<Text>(9);
        for (i in Iter.range(0, 8)) {
            result.add(cryptoIds[i]);
        };
        currentCryptos := Buffer.toArray(result);
        lastUpdate := Time.now();
    };

    // Initialize the cryptocurrencies
    updateCryptos();

    // System timer function for periodic updates
    system func timer(setTimer : Nat64 -> ()) : async () {
        updateCryptos();
        setTimer(3600_000_000_000); // Set timer for 1 hour (in nanoseconds)
    };

    // Public function to get current top 9 cryptocurrencies
    public query func getTopCryptos() : async [Text] {
        currentCryptos
    };

    // Get last update timestamp
    public query func getLastUpdate() : async Time.Time {
        lastUpdate
    };
}
