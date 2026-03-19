"use strict";

import { NitroModules } from 'react-native-nitro-modules';
import { SID_STAND } from "./NitroSber.nitro.js";
export const SberModule = NitroModules.createHybridObject('NitroSber');
export { SID_STAND };
export function initialize(props) {
  return SberModule.initialize(props.clientId, props.partnerName, props.userID, props.themeColorLight, props.themeColorDark, props.partnerProfileUrl, props.isShowErrorOnMain, props.standType);
}
export function auth(props) {
  return SberModule.auth(props.scope, props.state, props.nonce, props.redirectUri, props.ssoBaseUrl, props.codeChallenge, props.codeChallengeMethod, props.loginHint);
}
//# sourceMappingURL=index.js.map