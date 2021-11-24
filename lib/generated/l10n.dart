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
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `CLOSE`
  String get close {
    return Intl.message(
      'CLOSE',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get cancel {
    return Intl.message(
      'CANCEL',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `REMOVE`
  String get remove {
    return Intl.message(
      'REMOVE',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `DELETE`
  String get delete {
    return Intl.message(
      'DELETE',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `CHANGE`
  String get change {
    return Intl.message(
      'CHANGE',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `DONE`
  String get done {
    return Intl.message(
      'DONE',
      name: 'done',
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

  /// `Manage your script`
  String get onboardingManageScript {
    return Intl.message(
      'Manage your script',
      name: 'onboardingManageScript',
      desc: '',
      args: [],
    );
  }

  /// `Add, edit, and delete scripts. You can organize your created scripts by tagging them.`
  String get onboardingManageScriptDescription {
    return Intl.message(
      'Add, edit, and delete scripts. You can organize your created scripts by tagging them.',
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

  /// `You can play back your completed script. With speech recognition, you can see at a glance how far you have spoken.`
  String get onboardingPlayScriptDescription {
    return Intl.message(
      'You can play back your completed script. With speech recognition, you can see at a glance how far you have spoken.',
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

  /// `There is no script yet`
  String get noScriptYet {
    return Intl.message(
      'There is no script yet',
      name: 'noScriptYet',
      desc: '',
      args: [],
    );
  }

  /// `The trash can is empty`
  String get trashEmpty {
    return Intl.message(
      'The trash can is empty',
      name: 'trashEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No title`
  String get noTitle {
    return Intl.message(
      'No title',
      name: 'noTitle',
      desc: '',
      args: [],
    );
  }

  /// `No additional text`
  String get noAdditionalText {
    return Intl.message(
      'No additional text',
      name: 'noAdditionalText',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get placeholderTitle {
    return Intl.message(
      'Title',
      name: 'placeholderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter here`
  String get placeholderContent {
    return Intl.message(
      'Enter here',
      name: 'placeholderContent',
      desc: '',
      args: [],
    );
  }

  /// `Add new tag`
  String get addNewTag {
    return Intl.message(
      'Add new tag',
      name: 'addNewTag',
      desc: '',
      args: [],
    );
  }

  /// `Added a new tag.`
  String get newTagAdded {
    return Intl.message(
      'Added a new tag.',
      name: 'newTagAdded',
      desc: '',
      args: [],
    );
  }

  /// `Number of characters`
  String get characterCount {
    return Intl.message(
      'Number of characters',
      name: 'characterCount',
      desc: '',
      args: [],
    );
  }

  /// `Estimated presentation time (300 characters per minute)`
  String get estimatedReadingTime {
    return Intl.message(
      'Estimated presentation time (300 characters per minute)',
      name: 'estimatedReadingTime',
      desc: '',
      args: [],
    );
  }

  /// `Last modified`
  String get lastModified {
    return Intl.message(
      'Last modified',
      name: 'lastModified',
      desc: '',
      args: [],
    );
  }

  /// `{minutes}m {second}s`
  String time(Object minutes, Object second) {
    return Intl.message(
      '${minutes}m ${second}s',
      name: 'time',
      desc: '',
      args: [minutes, second],
    );
  }

  /// `Permanently delete`
  String get deletePermanently {
    return Intl.message(
      'Permanently delete',
      name: 'deletePermanently',
      desc: '',
      args: [],
    );
  }

  /// `The script has been permanently deleted.`
  String get permanentlyDeleted {
    return Intl.message(
      'The script has been permanently deleted.',
      name: 'permanentlyDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete {title} permanently?`
  String doDeletePermanently(Object title) {
    return Intl.message(
      'Do you want to delete $title permanently?',
      name: 'doDeletePermanently',
      desc: '',
      args: [title],
    );
  }

  /// `Restore`
  String get restore {
    return Intl.message(
      'Restore',
      name: 'restore',
      desc: '',
      args: [],
    );
  }

  /// `Move to trash`
  String get moveTrash {
    return Intl.message(
      'Move to trash',
      name: 'moveTrash',
      desc: '',
      args: [],
    );
  }

  /// `Search the script`
  String get searchScript {
    return Intl.message(
      'Search the script',
      name: 'searchScript',
      desc: '',
      args: [],
    );
  }

  /// `Edit tag`
  String get editTag {
    return Intl.message(
      'Edit tag',
      name: 'editTag',
      desc: '',
      args: [],
    );
  }

  /// `Remove tag`
  String get removeTag {
    return Intl.message(
      'Remove tag',
      name: 'removeTag',
      desc: '',
      args: [],
    );
  }

  /// `Remove {count} tags`
  String removeSelectTags(Object count) {
    return Intl.message(
      'Remove $count tags',
      name: 'removeSelectTags',
      desc: '',
      args: [count],
    );
  }

  /// `Do you want to remove the tag {name}? This operation cannot be undone.`
  String alertRemoveTag(Object name) {
    return Intl.message(
      'Do you want to remove the tag $name? This operation cannot be undone.',
      name: 'alertRemoveTag',
      desc: '',
      args: [name],
    );
  }

  /// `Do you want to remove all selected tags? This operation cannot be undone.`
  String get alertRemoveSelectTags {
    return Intl.message(
      'Do you want to remove all selected tags? This operation cannot be undone.',
      name: 'alertRemoveSelectTags',
      desc: '',
      args: [],
    );
  }

  /// `Removed tag.`
  String get tagRemoved {
    return Intl.message(
      'Removed tag.',
      name: 'tagRemoved',
      desc: '',
      args: [],
    );
  }

  /// `{count} tags removed.`
  String selectTagsRemoved(Object count) {
    return Intl.message(
      '$count tags removed.',
      name: 'selectTagsRemoved',
      desc: '',
      args: [count],
    );
  }

  /// `The contents of the trash will be completely removed after 7 days.`
  String get trashHint {
    return Intl.message(
      'The contents of the trash will be completely removed after 7 days.',
      name: 'trashHint',
      desc: '',
      args: [],
    );
  }

  /// `Trash`
  String get trash {
    return Intl.message(
      'Trash',
      name: 'trash',
      desc: '',
      args: [],
    );
  }

  /// `Tag`
  String get tag {
    return Intl.message(
      'Tag',
      name: 'tag',
      desc: '',
      args: [],
    );
  }

  /// `Change tag name`
  String get changeTagName {
    return Intl.message(
      'Change tag name',
      name: 'changeTagName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a name here`
  String get placeholderTagName {
    return Intl.message(
      'Enter a name here',
      name: 'placeholderTagName',
      desc: '',
      args: [],
    );
  }

  /// `Updated tag.`
  String get tagUpdated {
    return Intl.message(
      'Updated tag.',
      name: 'tagUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to empty the trash?`
  String get doEmptyTrash {
    return Intl.message(
      'Do you want to empty the trash?',
      name: 'doEmptyTrash',
      desc: '',
      args: [],
    );
  }

  /// `DELETE ALL`
  String get deleteAll {
    return Intl.message(
      'DELETE ALL',
      name: 'deleteAll',
      desc: '',
      args: [],
    );
  }

  /// `Emptied the trash.`
  String get trashEmptied {
    return Intl.message(
      'Emptied the trash.',
      name: 'trashEmptied',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tagList {
    return Intl.message(
      'Tags',
      name: 'tagList',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Format orientation`
  String get formatOrientation {
    return Intl.message(
      'Format orientation',
      name: 'formatOrientation',
      desc: '',
      args: [],
    );
  }

  /// `Horizontal`
  String get horizontal {
    return Intl.message(
      'Horizontal',
      name: 'horizontal',
      desc: '',
      args: [],
    );
  }

  /// `Vertical`
  String get vertical {
    return Intl.message(
      'Vertical',
      name: 'vertical',
      desc: '',
      args: [],
    );
  }

  /// `Play mode`
  String get playMode {
    return Intl.message(
      'Play mode',
      name: 'playMode',
      desc: '',
      args: [],
    );
  }

  /// `Manual scroll`
  String get manualScroll {
    return Intl.message(
      'Manual scroll',
      name: 'manualScroll',
      desc: '',
      args: [],
    );
  }

  /// `Auto scroll`
  String get autoScroll {
    return Intl.message(
      'Auto scroll',
      name: 'autoScroll',
      desc: '',
      args: [],
    );
  }

  /// `Speech recognition`
  String get speechRecognition {
    return Intl.message(
      'Speech recognition',
      name: 'speechRecognition',
      desc: '',
      args: [],
    );
  }

  /// `Does not scroll automatically.`
  String get manualScrollDescription {
    return Intl.message(
      'Does not scroll automatically.',
      name: 'manualScrollDescription',
      desc: '',
      args: [],
    );
  }

  /// `Scroll at a constant speed.`
  String get autoScrollDescription {
    return Intl.message(
      'Scroll at a constant speed.',
      name: 'autoScrollDescription',
      desc: '',
      args: [],
    );
  }

  /// `Scrolls by the amount of speech recognized text.`
  String get speechRecognitionDescription {
    return Intl.message(
      'Scrolls by the amount of speech recognized text.',
      name: 'speechRecognitionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Play speed`
  String get playSpeed {
    return Intl.message(
      'Play speed',
      name: 'playSpeed',
      desc: '',
      args: [],
    );
  }

  /// `About this app`
  String get aboutApp {
    return Intl.message(
      'About this app',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Open Source License`
  String get ossLicence {
    return Intl.message(
      'Open Source License',
      name: 'ossLicence',
      desc: '',
      args: [],
    );
  }

  /// `Play Settings`
  String get playSetting {
    return Intl.message(
      'Play Settings',
      name: 'playSetting',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Send feedback`
  String get sendFeedback {
    return Intl.message(
      'Send feedback',
      name: 'sendFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Microphone permission is required for speech recognition.`
  String get requirePermission {
    return Intl.message(
      'Microphone permission is required for speech recognition.',
      name: 'requirePermission',
      desc: '',
      args: [],
    );
  }

  /// `A network error has occurred.`
  String get networkError {
    return Intl.message(
      'A network error has occurred.',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `The microphone is busy.`
  String get micBusy {
    return Intl.message(
      'The microphone is busy.',
      name: 'micBusy',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String error(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'error',
      desc: '',
      args: [error],
    );
  }

  /// `RESET`
  String get resetInitValue {
    return Intl.message(
      'RESET',
      name: 'resetInitValue',
      desc: '',
      args: [],
    );
  }

  /// `HINT`
  String get hint {
    return Intl.message(
      'HINT',
      name: 'hint',
      desc: '',
      args: [],
    );
  }

  /// `If you don't want to play a sound during playback.`
  String get hintContent {
    return Intl.message(
      'If you don\'t want to play a sound during playback.',
      name: 'hintContent',
      desc: '',
      args: [],
    );
  }

  /// `Don't show again.`
  String get notShowAgain {
    return Intl.message(
      'Don\'t show again.',
      name: 'notShowAgain',
      desc: '',
      args: [],
    );
  }

  /// `OPEN SETTINGS`
  String get openSetting {
    return Intl.message(
      'OPEN SETTINGS',
      name: 'openSetting',
      desc: '',
      args: [],
    );
  }

  /// `Moved to the trash.`
  String get trashMoved {
    return Intl.message(
      'Moved to the trash.',
      name: 'trashMoved',
      desc: '',
      args: [],
    );
  }

  /// `UNDO`
  String get undo {
    return Intl.message(
      'UNDO',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `Deleted an empty script.`
  String get emptyScriptDeleted {
    return Intl.message(
      'Deleted an empty script.',
      name: 'emptyScriptDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Restored from the trash.`
  String get trashRestored {
    return Intl.message(
      'Restored from the trash.',
      name: 'trashRestored',
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