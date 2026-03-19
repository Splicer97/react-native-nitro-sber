import type { HybridObject } from 'react-native-nitro-modules';
export declare enum SID_STAND {
    PSI_CLOUD_STAND = "psi_cloud",
    PROM_STAND = "prom",
    PSI_STAND = "psi",
    IFT_STAND = "ift",
    IFT_CLOUD_STAND = "ift_cloud"
}
export interface NitroSber extends HybridObject<{
    ios: 'swift';
    android: 'kotlin';
}> {
    closeAuthorizationViewControllers(): void;
    auth(scope: string, state: string, nonce: string, redirectUri: string, ssoBaseUrl: string | undefined, codeChallenge: string | undefined, codeChallengeMethod: string | undefined, loginHint: string | undefined): Promise<void>;
    initialize(clientId: string, partnerName: string | undefined, userID: string | undefined, themeColorLight: string | undefined, themeColorDark: string | undefined, partnerProfileUrl: string | undefined, isShowErrorOnMain: boolean | undefined, standType: SID_STAND | undefined): Promise<void>;
}
//# sourceMappingURL=NitroSber.nitro.d.ts.map