import Bool "mo:base/Bool";
import Float "mo:base/Float";
import Nat "mo:base/Nat";

import Random "mo:base/Random";
import Timer "mo:base/Timer";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Nat8 "mo:base/Nat8";
import Error "mo:base/Error";

actor {
    type CryptoData = {
        id: Text;
        price: Float;
        lastUpdate: Time.Time;
    };

    stable var currentCryptos : [CryptoData] = [];
    stable var lastUpdate : Time.Time = 0;

    let cryptoIds : [Text] = [
        "bitcoin", "ethereum", "tether", "binancecoin", "ripple", "usd-coin", "steth", 
        "cardano", "dogecoin", "solana", "tron", "polkadot", "matic-network", "litecoin",
        "wrapped-bitcoin", "dai", "chainlink", "shiba-inu", "bitcoin-cash", "avalanche-2"
    ];

    // Select random cryptocurrencies
    public func getRandomCryptos() : async [Text] {
        let seed = await Random.blob();
        let randGen = Random.Finite(seed);
        let result = Buffer.Buffer<Text>(9);
        let used = Buffer.Buffer<Bool>(cryptoIds.size());
        
        for (_ in Iter.range(0, cryptoIds.size() - 1)) {
            used.add(false);
        };

        var count = 0;
        while (count < 9) {
            switch (randGen.byte()) {
                case null { };
                case (?val) {
                    let index = Nat8.toNat(val) % cryptoIds.size();
                    if (not Buffer.toArray(used)[index]) {
                        result.add(cryptoIds[index]);
                        used.put(index, true);
                        count += 1;
                    };
                };
            };
        };
        
        Buffer.toArray(result)
    };

    // Update crypto prices from frontend
    public func updateCryptoPrices(cryptos: [(Text, Float)]) : async () {
        let result = Buffer.Buffer<CryptoData>(9);
        for ((id, price) in cryptos.vals()) {
            result.add({
                id = id;
                price = price;
                lastUpdate = Time.now();
            });
        };
        currentCryptos := Buffer.toArray(result);
        lastUpdate := Time.now();
    };

    // Public query function to get current crypto data
    public query func getCurrentCryptos() : async [CryptoData] {
        currentCryptos
    };

    // Get last update timestamp
    public query func getLastUpdate() : async Time.Time {
        lastUpdate
    };
}
