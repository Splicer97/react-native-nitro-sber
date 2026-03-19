import Foundation
import UIKit
import NitroModules
import SIDSDK

final class NitroSber: HybridNitroSberSpec {
  private enum Storage {
    static weak var lastTopViewController: UIViewController?
  }

  func closeAuthorizationViewControllers() throws -> Void {
    DispatchQueue.main.async {
      let top = Storage.lastTopViewController ?? UIViewController.nitro_currentTopMost
      top?.presentedViewController?.dismiss(animated: true)
    }
  }

  func initialize(
    clientId: String,
    partnerName: String?,
    userID: String?,
    themeColorLight: String?,
    themeColorDark: String?,
    partnerProfileUrl: String?,
    isShowErrorOnMain: Bool?,
    standType: SID_STAND?
  ) throws -> Promise<Void> {
    return Promise.parallel(.main) {
      let themeColor = SIDColor(
        light: UIColor(hex: themeColorLight) ?? .brand,
        dark: UIColor(hex: themeColorDark) ?? .brand
      )
      let uiPreferences = SIDUIPreferences(
        themeColor: themeColor,
        elkErrorType: (isShowErrorOnMain ?? false) ? .type3 : SIDErrorTypes.none
      )

      // NOTE: SIDSDK iOS is stateful and should be initialized early.
      SID.initializer.initialize(stand: SIDStandType(fromString: standType?.stringValue ?? "prom"))
      SID.settings.applyUIPreferences(preferences: uiPreferences)
      SID.settings.applyMainPreferences(
        clientID: clientId,
        userID: userID,
        partnerName: partnerName,
        partnerProfileUrl: partnerProfileUrl
      )
    }
  }

  func auth(
    scope: String,
    state: String,
    nonce: String,
    redirectUri: String,
    ssoBaseUrl: String?,
    codeChallenge: String?,
    codeChallengeMethod: String?,
    loginHint: String?
  ) throws -> Promise<Void> {
    return Promise.parallel(.main) {
      let request = SIDAuthRequest(
        scope: scope,
        state: state,
        nonce: nonce,
        redirectUri: redirectUri,
        ssoBaseUrl: ssoBaseUrl,
        codeChallenge: codeChallenge,
        codeChallengeMethod: codeChallengeMethod ?? SIDAuthRequest.challengeMethod,
        loginHint: loginHint
      )

      let currentVC = UIViewController.nitro_currentTopMost ?? UIViewController()
      Storage.lastTopViewController = currentVC

      SID.login.auth(request: request, viewController: currentVC)
    }
  }
}

private extension UIViewController {
  static var nitro_currentTopMost: UIViewController? {
    guard Thread.isMainThread else {
      // best-effort: caller will schedule on main anyway
      return nil
    }

    let scenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }

    let window = scenes
      .flatMap { $0.windows }
      .first(where: { $0.isKeyWindow }) ?? scenes.flatMap { $0.windows }.first

    var top = window?.rootViewController
    while true {
      if let presented = top?.presentedViewController {
        top = presented
        continue
      }
      if let nav = top as? UINavigationController {
        top = nav.visibleViewController
        continue
      }
      if let tab = top as? UITabBarController {
        top = tab.selectedViewController
        continue
      }
      break
    }
    return top
  }
}
