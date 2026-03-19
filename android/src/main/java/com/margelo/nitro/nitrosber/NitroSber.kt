package com.margelo.nitro.nitrosber

import android.app.Application
import android.graphics.Color
import android.util.Log
import androidx.fragment.app.FragmentActivity
import com.facebook.proguard.annotations.DoNotStrip
import com.margelo.nitro.NitroModules
import com.margelo.nitro.core.Promise
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import sid.sdk.core.global.models.SIDColorCore
import sid.sdk.core.global.models.SIDPreferencesCore
import sid.sdk.core.global.models.StandName
import sid.sdk.core.init.SID
import kotlin.coroutines.CoroutineContext
import sid.sdk.core.auth.init.SIDLogin.Login

@DoNotStrip
class NitroSber : HybridNitroSberSpec() {
  private val logHandler: CoroutineExceptionHandler by lazy {
    CoroutineExceptionHandler { _: CoroutineContext, throwable: Throwable ->
      Log.e(TAG, "Unhandled exception", throwable)
    }
  }

  private val mainScope = CoroutineScope(Dispatchers.Main.immediate + logHandler)

  override fun closeAuthorizationViewControllers() {
    // no-op on Android
  }

  override fun initialize(
    clientId: String,
    partnerName: String?,
    userID: String?,
    themeColorLight: String?,
    themeColorDark: String?,
    partnerProfileUrl: String?,
    isShowErrorOnMain: Boolean?,
    standType: SID_STAND?,
  ): Promise<Unit> {
    return Promise.async(mainScope) {
      val reactContext = NitroModules.applicationContext
        ?: throw IllegalStateException("NitroModules.applicationContext is null. Did you call NitroModules.install()?")

      val application: Application =
        reactContext.currentActivity?.application
          ?: (reactContext.applicationContext as? Application)
          ?: throw IllegalStateException("Failed to get Android Application instance!")

      SID.Initializer.initialize(application = application)

      SID.Settings.setMainSettings(
        clientID = clientId,
        userID = userID,
        stand = toStandName(standType),
      )

      val lightInt = themeColorLight?.let { runCatching { Color.parseColor(it) }.getOrNull() }
      val darkInt = themeColorDark?.let { runCatching { Color.parseColor(it) }.getOrNull() }
      if (lightInt != null || darkInt != null) {
        SID.Settings.setUIPreferencesCore(
          preferences = SIDPreferencesCore(
            themeColor = SIDColorCore(
              light = lightInt,
              dark = darkInt,
            )
          )
        )
      }
    }
  }

  override fun auth(
    scope: String,
    state: String,
    nonce: String,
    redirectUri: String,
    ssoBaseUrl: String?,
    codeChallenge: String?,
    codeChallengeMethod: String?,
    loginHint: String?,
  ): Promise<Unit> {
    return Promise.async(mainScope) {
      val reactContext = NitroModules.applicationContext
        ?: throw IllegalStateException("NitroModules.applicationContext is null. Did you call NitroModules.install()?")

      val activity = reactContext.currentActivity as? FragmentActivity
        ?: throw IllegalStateException("Current Activity is not a FragmentActivity!")

      val loginUri = SID.Login.createLoginUri(
        scope = scope,
        state = state,
        nonce = nonce,
        redirectUri = redirectUri,
        codeChallenge = codeChallenge,
        codeChallengeMethod = codeChallengeMethod,
        uriScheme = ssoBaseUrl,
        loginHint = loginHint
      )

      SID.Login.loginWithID(activity, loginUri)
    }
  }

  private fun toStandName(standType: SID_STAND?): StandName {
    return when (standType) {
      SID_STAND.PSI_CLOUD -> StandName.CLOUD_PSI
      SID_STAND.PROM -> StandName.PROM
      SID_STAND.PSI -> StandName.ESA_PSI
      SID_STAND.IFT -> StandName.ESA_IFT
      SID_STAND.IFT_CLOUD -> StandName.CLOUD_IFT
      null -> StandName.PROM
    }
  }

  private companion object {
    private const val TAG = "NitroSber"
  }
}
