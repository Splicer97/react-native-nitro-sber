import { NitroModules } from 'react-native-nitro-modules';
import type { NitroSber } from './NitroSber.nitro';
import { SID_STAND } from './NitroSber.nitro';

export const SberModule =
  NitroModules.createHybridObject<NitroSber>('NitroSber');

export { SID_STAND };

export type InitializeProps = {
  clientId: string;
  partnerName?: string;
  userID?: string;
  themeColorLight?: string;
  themeColorDark?: string;
  partnerProfileUrl?: string;
  isShowErrorOnMain?: boolean;
  standType?: SID_STAND;
};

export function initialize(props: InitializeProps): Promise<void> {
  return SberModule.initialize(
    props.clientId,
    props.partnerName,
    props.userID,
    props.themeColorLight,
    props.themeColorDark,
    props.partnerProfileUrl,
    props.isShowErrorOnMain,
    props.standType
  );
}

export type AuthProps = {
  scope: string;
  state: string;
  nonce: string;
  redirectUri: string;
  ssoBaseUrl?: string;
  codeChallenge?: string;
  codeChallengeMethod?: string;
  loginHint?: string;
};

export function auth(props: AuthProps): Promise<void> {
  return SberModule.auth(
    props.scope,
    props.state,
    props.nonce,
    props.redirectUri,
    props.ssoBaseUrl,
    props.codeChallenge,
    props.codeChallengeMethod,
    props.loginHint
  );
}
