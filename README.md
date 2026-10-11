# Presc
[![Android DeployGate CI/CD](https://github.com/sakusaku3939/Presc/actions/workflows/android.yml/badge.svg)](https://github.com/sakusaku3939/Presc/actions/workflows/android.yml) [![iOS CI/CD](https://github.com/sakusaku3939/Presc/actions/workflows/ios.yml/badge.svg)](https://github.com/sakusaku3939/Presc/actions/workflows/ios.yml) ![License](https://img.shields.io/github/license/sakusaku3939/presc)  

スマホに表示した原稿を、話した分だけ自動でスクロールしてくれる「プレゼンテーション用原稿表示アプリ」です。  
話し手の音声をアプリが自動認識してくれ、どこまで読んだかが一目で分かります。  

<a href='https://play.google.com/store/apps/details?id=com.sakusaku3939.presc'>
  <img height=70 src='https://user-images.githubusercontent.com/53967490/160243927-463746b7-721a-4829-961b-ecf482d7dfca.png'/>
</a>　
<a href='https://apps.apple.com/jp/app/presc/id1599599891'>
  <img height=70 src='https://user-images.githubusercontent.com/53967490/160243929-be38cf88-c4d4-4096-896d-fa5b55d1417c.png'/>
</a>

<br>
<br>

![presc](https://user-images.githubusercontent.com/53967490/139699408-2ef6dc85-83c4-4dcf-90b6-293bd9071d30.jpg)

# Usage

Flutter 3.47.7 (stable) / Dart 3.13.5、Android API 24以上、iOS 15以上。
FVMでSDKを固定しているため、Flutter/Dartコマンドは `fvm` 経由で実行してください。
AndroidはAGP 9.1.0 / Gradle 9.3.1 / Kotlin 2.4.0 / Java 17以上を使用します。
`flutter_sharing_intent` と `in_app_review` が旧Kotlin設定を使うため、Flutter標準の移行設定
`android.builtInKotlin=false` と `android.newDsl=false` を保持しています。

```
fvm install
fvm flutter pub get
fvm flutter analyze
fvm flutter test
```
### Debug
```
fvm flutter pub get
fvm dart run intl_utils:generate
fvm flutter run --flavor beta
```

### Release
```
fvm flutter build appbundle --release --flavor stable
```
```
fvm flutter build ipa
open build/ios/archive/Runner.xcarchive
```

### iOS CI
署名なしのリリースビルド・解析・テストを確認する場合:
```
gh workflow run ios.yml --ref master -f distribute=false
```
`distribute=true`（既定値）では署名付きIPAを生成してDeployGateに配布します。
GitHub Secretsには、有効な配布証明書とRunner・Share Extension両方のProvisioning Profileが必要です。

# License
GPL-3.0 License
