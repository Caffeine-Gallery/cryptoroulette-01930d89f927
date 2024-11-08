export const idlFactory = ({ IDL }) => {
  const Time = IDL.Int;
  return IDL.Service({
    'getLastUpdate' : IDL.Func([], [Time], ['query']),
    'getTopCryptos' : IDL.Func([], [IDL.Vec(IDL.Text)], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
