export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'getTopCryptos' : IDL.Func([], [IDL.Vec(IDL.Text)], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
