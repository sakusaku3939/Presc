// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Next`
  String get onboardingNext {
    return Intl.message(
      'Next',
      name: 'onboardingNext',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get onboardingSkip {
    return Intl.message(
      'Skip',
      name: 'onboardingSkip',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get onboardingStart {
    return Intl.message(
      'Start',
      name: 'onboardingStart',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Presc`
  String get onboardingWelcomePresc {
    return Intl.message(
      'Welcome to Presc',
      name: 'onboardingWelcomePresc',
      desc: '',
      args: [],
    );
  }

  /// `Presc is a script display application that can be used for presentations, lectures, speeches, etc.`
  String get onboardingWelcomePrescDescription {
    return Intl.message(
      'Presc is a script display application that can be used for presentations, lectures, speeches, etc.',
      name: 'onboardingWelcomePrescDescription',
      desc: '',
      args: [],
    );
  }

  /// `Manage your manuscript`
  String get onboardingManageScript {
    return Intl.message(
      'Manage your manuscript',
      name: 'onboardingManageScript',
      desc: '',
      args: [],
    );
  }

  /// `Add, edit, and delete manuscripts. You can organize your created manuscripts by tagging them.`
  String get onboardingManageScriptDescription {
    return Intl.message(
      'Add, edit, and delete manuscripts. You can organize your created manuscripts by tagging them.',
      name: 'onboardingManageScriptDescription',
      desc: '',
      args: [],
    );
  }

  /// `Play the script`
  String get onboardingPlayScript {
    return Intl.message(
      'Play the script',
      name: 'onboardingPlayScript',
      desc: '',
      args: [],
    );
  }

  /// `You can play back your completed manuscript. With speech recognition, you can see at a glance how far you have spoken.`
  String get onboardingPlayScriptDescription {
    return Intl.message(
      'You can play back your completed manuscript. With speech recognition, you can see at a glance how far you have spoken.',
      name: 'onboardingPlayScriptDescription',
      desc: '',
      args: [],
    );
  }

  /// `Customize as you like`
  String get onboardingCustomize {
    return Intl.message(
      'Customize as you like',
      name: 'onboardingCustomize',
      desc: '',
      args: [],
    );
  }

  /// `You can customize the orientation of the formatting (vertical or horizontal), the color of the text, the font size, etc.`
  String get onboardingCustomizeDescription {
    return Intl.message(
      'You can customize the orientation of the formatting (vertical or horizontal), the color of the text, the font size, etc.',
      name: 'onboardingCustomizeDescription',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}