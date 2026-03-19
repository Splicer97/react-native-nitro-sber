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
        light: UIColor(nitroHex: themeColorLight) ?? .brand,
        dark: UIColor(nitroHex: themeColorDark) ?? .brand
      )
      let uiPreferences = SIDUIPreferences(
        themeColor: themeColor,
        elkErrorType: (isShowErrorOnMain ?? false) ? .type3 : SIDErrorTypes.none
      )

      // NOTE: SIDSDK iOS is stateful and should be initialized early.
      SID.initializer.initialize(stand: Self.toSidStandType(standType))
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

  private static func toSidStandType(_ standType: SID_STAND?) -> SIDStandType {
    // Map TS enum to SIDSDK stand type.
    switch standType {
    case .psiCloud:
      return SIDStandType(fromString: "psi_cloud")
    case .prom:
      return SIDStandType(fromString: "prom")
    case .psi:
      return SIDStandType(fromString: "psi")
    case .ift:
      return SIDStandType(fromString: "ift")
    case .iftCloud:
      return SIDStandType(fromString: "ift_cloud")
    case nil:
      return SIDStandType(fromString: "prom")
    }
  }
}

private extension UIColor {
  /// Parses "#RRGGBB" / "RRGGBB" / "#AARRGGBB" / "AARRGGBB".
  convenience init?(nitroHex: String?) {
    guard var hex = nitroHex?.trimmingCharacters(in: .whitespacesAndNewlines), !hex.isEmpty else {
      return nil
    }
    if hex.hasPrefix("#") { hex.removeFirst() }

    let value = UInt64(hex, radix: 16)
    guard let value else { return nil }

    let a, r, g, b: UInt64
    switch hex.count {
    case 6:
      a = 0xFF
      r = (value >> 16) & 0xFF
      g = (value >> 8) & 0xFF
      b = value & 0xFF
    case 8:
      a = (value >> 24) & 0xFF
      r = (value >> 16) & 0xFF
      g = (value >> 8) & 0xFF
      b = value & 0xFF
    default:
      return nil
    }

    self.init(
      red: CGFloat(r) / 255.0,
      green: CGFloat(g) / 255.0,
      blue: CGFloat(b) / 255.0,
      alpha: CGFloat(a) / 255.0
    )
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
