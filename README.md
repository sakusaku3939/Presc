# Presc
[![Android DeployGate CI/CD](https://github.com/sakusaku3939/Presc/actions/workflows/android.yml/badge.svg)](https://github.com/sakusaku3939/Presc/actions/workflows/android.yml) [![iOS CI/CD](https://github.com/sakusaku3939/Presc/actions/workflows/ios.yml/badge.svg)](https://github.com/sakusaku3939/Presc/actions/workflows/ios.yml) ![License](https://img.shields.io/github/license/sakusaku3939/presc)  

スマホに表示した原稿を、話した分だけ自動でスクロールしてくれる「プレゼンテーション用原稿表示アプリ」です。  
話し手の音声をアプリが自動認識してくれ、どこまで読んだかが一目で分かります。  
https://sakusaku3939.com/?posts=presc  

<a href='https://play.google.com/store/apps/details?id=com.sakusaku3939.presc'>
  <img height=70 src='https://user-images.githubusercontent.com/53967490/160243927-463746b7-721a-4829-961b-ecf482d7dfca.png'/>
</a>　
<a href='https://apps.apple.com/jp/app/presc/id1599599891'>
  <img height=70 src='https://user-images.githubusercontent.com/53967490/160243929-be38cf88-c4d4-4096-896d-fa5b55d1417c.png'/>
</a>

<br>
<br>

![presc](https://user-images.githubusercontent.com/53967490/139699408-2ef6dc85-83c4-4dcf-90b6-293bd9071d30.jpg)

# Debug build
```
fvm flutter pub get
fvm flutter pub run intl_utils:generate
fvm flutter run --flavor beta
```

# Release build
```
fvm flutter build appbundle --release --flavor stable
```
```
fvm flutter build ipa open build/ios/archive/Runner.xcarchive
```


# License
GPL-3.0 License
