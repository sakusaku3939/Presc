import UIKit
import Flutter
import flutter_sharing_intent

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let sharingIntent = SwiftFlutterSharingIntentPlugin.instance
    for context in connectionOptions.urlContexts where sharingIntent.hasSameSchemePrefix(url: context.url) {
      _ = sharingIntent.application(
        UIApplication.shared,
        didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: context.url]
      )
    }
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    let sharingIntent = SwiftFlutterSharingIntentPlugin.instance
    for context in URLContexts where sharingIntent.hasSameSchemePrefix(url: context.url) {
      _ = sharingIntent.application(UIApplication.shared, open: context.url, options: [:])
    }
    super.scene(scene, openURLContexts: URLContexts)
  }
}
