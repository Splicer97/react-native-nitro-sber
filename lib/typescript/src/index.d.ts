import type { NitroSber } from './NitroSber.nitro';
import { SID_STAND } from './NitroSber.nitro';
export declare const SberModule: NitroSber;
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
export declare function initialize(props: InitializeProps): Promise<void>;
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
export declare function auth(props: AuthProps): Promise<void>;
//# sourceMappingURL=index.d.ts.map