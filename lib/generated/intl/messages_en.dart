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

  static m0(name) => "Do you want to remove the tag ${name}? This operation cannot be undone.";

  static m1(error) => "Error: ${error}";

  static m2(count) => "Remove ${count} tags";

  static m3(count) => "${count} tags removed.";

  static m4(minutes, second) => "${minutes}m ${second}s";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aboutApp" : MessageLookupByLibrary.simpleMessage("About this app"),
    "addNewTag" : MessageLookupByLibrary.simpleMessage("Add new tag"),
    "alertRemoveSelectTags" : MessageLookupByLibrary.simpleMessage("Do you want to remove all selected tags? This operation cannot be undone."),
    "alertRemoveTag" : m0,
    "autoScroll" : MessageLookupByLibrary.simpleMessage("Auto scroll"),
    "autoScrollDescription" : MessageLookupByLibrary.simpleMessage("Scroll at a constant speed."),
    "cancel" : MessageLookupByLibrary.simpleMessage("CANCEL"),
    "change" : MessageLookupByLibrary.simpleMessage("CHANGE"),
    "changeTagName" : MessageLookupByLibrary.simpleMessage("Change tag name"),
    "characterCount" : MessageLookupByLibrary.simpleMessage("Number of characters"),
    "close" : MessageLookupByLibrary.simpleMessage("CLOSE"),
    "deleteAll" : MessageLookupByLibrary.simpleMessage("DELETE ALL"),
    "doEmptyTrash" : MessageLookupByLibrary.simpleMessage("Do you want to empty the trash?"),
    "done" : MessageLookupByLibrary.simpleMessage("DONE"),
    "edit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "editTag" : MessageLookupByLibrary.simpleMessage("Edit tag"),
    "error" : m1,
    "estimatedReadingTime" : MessageLookupByLibrary.simpleMessage("Estimated presentation time (300 characters per minute)"),
    "formatOrientation" : MessageLookupByLibrary.simpleMessage("Format orientation"),
    "hint" : MessageLookupByLibrary.simpleMessage("HINT"),
    "hintContent" : MessageLookupByLibrary.simpleMessage("If you don\'t want to play a sound during playback."),
    "horizontal" : MessageLookupByLibrary.simpleMessage("Horizontal"),
    "lastModified" : MessageLookupByLibrary.simpleMessage("Last modified"),
    "manualScroll" : MessageLookupByLibrary.simpleMessage("Manual scroll"),
    "manualScrollDescription" : MessageLookupByLibrary.simpleMessage("Does not scroll automatically."),
    "micBusy" : MessageLookupByLibrary.simpleMessage("The microphone is busy."),
    "moveTrash" : MessageLookupByLibrary.simpleMessage("Move to trash"),
    "networkError" : MessageLookupByLibrary.simpleMessage("A network error has occurred."),
    "newTagAdded" : MessageLookupByLibrary.simpleMessage("Added a new tag"),
    "next" : MessageLookupByLibrary.simpleMessage("Next"),
    "noAdditionalText" : MessageLookupByLibrary.simpleMessage("No additional text"),
    "noScriptYet" : MessageLookupByLibrary.simpleMessage("There is no script yet"),
    "noTitle" : MessageLookupByLibrary.simpleMessage("No title"),
    "notShowAgain" : MessageLookupByLibrary.simpleMessage("Don\'t show again."),
    "onboardingCustomize" : MessageLookupByLibrary.simpleMessage("Customize as you like"),
    "onboardingCustomizeDescription" : MessageLookupByLibrary.simpleMessage("You can customize the orientation of the formatting (vertical or horizontal), the color of the text, the font size, etc."),
    "onboardingManageScript" : MessageLookupByLibrary.simpleMessage("Manage your script"),
    "onboardingManageScriptDescription" : MessageLookupByLibrary.simpleMessage("Add, edit, and delete scripts. You can organize your created scripts by tagging them."),
    "onboardingPlayScript" : MessageLookupByLibrary.simpleMessage("Play the script"),
    "onboardingPlayScriptDescription" : MessageLookupByLibrary.simpleMessage("You can play back your completed script. With speech recognition, you can see at a glance how far you have spoken."),
    "onboardingStart" : MessageLookupByLibrary.simpleMessage("Start"),
    "onboardingWelcomePresc" : MessageLookupByLibrary.simpleMessage("Welcome to Presc"),
    "onboardingWelcomePrescDescription" : MessageLookupByLibrary.simpleMessage("Presc is a script display application that can be used for presentations, lectures, speeches, etc."),
    "openSetting" : MessageLookupByLibrary.simpleMessage("OPEN SETTINGS"),
    "ossLicence" : MessageLookupByLibrary.simpleMessage("Open Source License"),
    "permanentlyDeleted" : MessageLookupByLibrary.simpleMessage("Permanently deleted"),
    "placeholderContent" : MessageLookupByLibrary.simpleMessage("Enter here"),
    "placeholderTagName" : MessageLookupByLibrary.simpleMessage("Enter a name here"),
    "placeholderTitle" : MessageLookupByLibrary.simpleMessage("Title"),
    "playMode" : MessageLookupByLibrary.simpleMessage("Play mode"),
    "playSetting" : MessageLookupByLibrary.simpleMessage("Play Settings"),
    "playSpeed" : MessageLookupByLibrary.simpleMessage("Play speed"),
    "privacyPolicy" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "remove" : MessageLookupByLibrary.simpleMessage("REMOVE"),
    "removeSelectTags" : m2,
    "removeTag" : MessageLookupByLibrary.simpleMessage("Remove tag"),
    "requirePermission" : MessageLookupByLibrary.simpleMessage("Microphone permission is required for speech recognition."),
    "resetInitValue" : MessageLookupByLibrary.simpleMessage("RESET"),
    "restore" : MessageLookupByLibrary.simpleMessage("Restore"),
    "searchScript" : MessageLookupByLibrary.simpleMessage("Search the script"),
    "selectTagsRemoved" : m3,
    "sendFeedback" : MessageLookupByLibrary.simpleMessage("Send feedback"),
    "setting" : MessageLookupByLibrary.simpleMessage("Settings"),
    "skip" : MessageLookupByLibrary.simpleMessage("Skip"),
    "speechRecognition" : MessageLookupByLibrary.simpleMessage("Speech recognition"),
    "speechRecognitionDescription" : MessageLookupByLibrary.simpleMessage("Scrolls by the amount of speech recognized text."),
    "tag" : MessageLookupByLibrary.simpleMessage("Tag"),
    "tagList" : MessageLookupByLibrary.simpleMessage("Tags"),
    "tagRemoved" : MessageLookupByLibrary.simpleMessage("Removed tag."),
    "tagUpdated" : MessageLookupByLibrary.simpleMessage("Updated tag"),
    "time" : m4,
    "trash" : MessageLookupByLibrary.simpleMessage("Trash"),
    "trashEmptied" : MessageLookupByLibrary.simpleMessage("Emptied the trash."),
    "trashEmpty" : MessageLookupByLibrary.simpleMessage("The trash can is empty"),
    "trashHint" : MessageLookupByLibrary.simpleMessage("The contents of the trash will be completely removed after 7 days."),
    "vertical" : MessageLookupByLibrary.simpleMessage("Vertical")
  };
}
