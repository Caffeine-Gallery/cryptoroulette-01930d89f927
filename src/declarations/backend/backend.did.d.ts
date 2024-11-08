import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface CryptoData {
  'id' : string,
  'lastUpdate' : Time,
  'price' : number,
}
export type Time = bigint;
export interface _SERVICE {
  'getCurrentCryptos' : ActorMethod<[], Array<CryptoData>>,
  'getLastUpdate' : ActorMethod<[], Time>,
  'getRandomCryptos' : ActorMethod<[], Array<string>>,
  'updateCryptoPrices' : ActorMethod<[Array<[string, number]>], undefined>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
