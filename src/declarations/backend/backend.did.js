export const idlFactory = ({ IDL }) => {
  const Time = IDL.Int;
  const CryptoData = IDL.Record({
    'id' : IDL.Text,
    'lastUpdate' : Time,
    'price' : IDL.Float64,
  });
  return IDL.Service({
    'getCurrentCryptos' : IDL.Func([], [IDL.Vec(CryptoData)], ['query']),
    'getLastUpdate' : IDL.Func([], [Time], ['query']),
    'getRandomCryptos' : IDL.Func([], [IDL.Vec(IDL.Text)], []),
    'updateCryptoPrices' : IDL.Func(
        [IDL.Vec(IDL.Tuple(IDL.Text, IDL.Float64))],
        [],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
