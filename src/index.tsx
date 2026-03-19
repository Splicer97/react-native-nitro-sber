import { NitroModules } from 'react-native-nitro-modules';
import type { NitroSber } from './NitroSber.nitro';

const NitroSberHybridObject =
  NitroModules.createHybridObject<NitroSber>('NitroSber');

export function multiply(a: number, b: number): number {
  return NitroSberHybridObject.multiply(a, b);
}
