import { NitroModules } from 'react-native-nitro-modules';
import type { NitroSber } from './NitroSber.nitro';

export const SberModule =
  NitroModules.createHybridObject<NitroSber>('NitroSber');

export { SID_STAND } from './NitroSber.nitro';
