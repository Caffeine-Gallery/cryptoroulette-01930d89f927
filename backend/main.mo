import Bool "mo:base/Bool";
import Func "mo:base/Func";
import List "mo:base/List";

import Random "mo:base/Random";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Nat8 "mo:base/Nat8";
import Nat "mo:base/Nat";

actor {
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

    // Function to get random crypto IDs
    public func getRandomCryptos() : async [Text] {
        let seed = Random.Finite(await Random.blob());
        let selectedIndices = Buffer.Buffer<Nat>(10);
        var attempts = 0;

        while (selectedIndices.size() < 10 and attempts < 100) {
            switch (seed.byte()) {
                case null { attempts += 1; };
                case (?val) {
                    let index = Nat8.toNat(val) % cryptoIds.size();
                    let exists = Array.find<Nat>(
                        Buffer.toArray(selectedIndices),
                        func (x : Nat) : Bool { x == index }
                    );
                    switch (exists) {
                        case null { selectedIndices.add(index); };
                        case (?_) { };
                    };
                    attempts += 1;
                };
            };
        };

        let result = Buffer.Buffer<Text>(10);
        for (index in selectedIndices.vals()) {
            result.add(cryptoIds[index]);
        };
        
        Buffer.toArray(result)
    };
}
