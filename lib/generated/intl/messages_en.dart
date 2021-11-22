// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "onboardingCustomize" : MessageLookupByLibrary.simpleMessage("Customize as you like"),
    "onboardingCustomizeDescription" : MessageLookupByLibrary.simpleMessage("You can customize the orientation of the formatting (vertical or horizontal), the color of the text, the font size, etc."),
    "onboardingManageScript" : MessageLookupByLibrary.simpleMessage("Manage your manuscript"),
    "onboardingManageScriptDescription" : MessageLookupByLibrary.simpleMessage("Add, edit, and delete manuscripts. You can organize your created manuscripts by tagging them."),
    "onboardingNext" : MessageLookupByLibrary.simpleMessage("Next"),
    "onboardingPlayScript" : MessageLookupByLibrary.simpleMessage("Play the script"),
    "onboardingPlayScriptDescription" : MessageLookupByLibrary.simpleMessage("You can play back your completed manuscript. With speech recognition, you can see at a glance how far you have spoken."),
    "onboardingSkip" : MessageLookupByLibrary.simpleMessage("Skip"),
    "onboardingStart" : MessageLookupByLibrary.simpleMessage("Start"),
    "onboardingWelcomePresc" : MessageLookupByLibrary.simpleMessage("Welcome to Presc"),
    "onboardingWelcomePrescDescription" : MessageLookupByLibrary.simpleMessage("Presc is a script display application that can be used for presentations, lectures, speeches, etc.")
  };
}
