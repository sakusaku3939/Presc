// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Failed to add manuscript: ${error}";

  static String m1(name) =>
      "Do you want to remove the tag ${name}? This operation cannot be undone.";

  static String m2(error) => "Failed to restore backup: ${error}";

  static String m3(error) => "Failed to save backup: ${error}";

  static String m4(unit) => "Number of ${unit}";

  static String m5(title) => "Do you want to delete ${title} permanently?";

  static String m6(error) => "Error: ${error}";

  static String m7(perMinute) => "Estimated presentation time (${perMinute})";

  static String m8(count) => "Remove ${count} tags";

  static String m9(error) => "Failed to restore backup: ${error}";

  static String m10(count) => "${count} tags removed.";

  static String m11(minutes, second) => "${minutes}m ${second}s";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutApp": MessageLookupByLibrary.simpleMessage("About this app"),
    "addManuscriptFailed": m0,
    "addNewTag": MessageLookupByLibrary.simpleMessage("Add new tag"),
    "alertRemoveSelectTags": MessageLookupByLibrary.simpleMessage(
      "Do you want to remove all selected tags? This operation cannot be undone.",
    ),
    "alertRemoveTag": m1,
    "autoScroll": MessageLookupByLibrary.simpleMessage("Auto scroll"),
    "autoScrollDescription": MessageLookupByLibrary.simpleMessage(
      "Scroll at a constant speed.",
    ),
    "backup": MessageLookupByLibrary.simpleMessage("Backup"),
    "backupManuscript": MessageLookupByLibrary.simpleMessage(
      "Backup Manuscript",
    ),
    "backupManuscriptDescription": MessageLookupByLibrary.simpleMessage(
      "Backup manuscripts to external storage",
    ),
    "backupRestoreFailed": m2,
    "backupRestored": MessageLookupByLibrary.simpleMessage(
      "Manuscript backup has been restored",
    ),
    "backupSaveFailed": m3,
    "backupSaved": MessageLookupByLibrary.simpleMessage(
      "Manuscript backup has been saved",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("CANCEL"),
    "change": MessageLookupByLibrary.simpleMessage("CHANGE"),
    "changeTagName": MessageLookupByLibrary.simpleMessage("Change tag name"),
    "characterCount": m4,
    "close": MessageLookupByLibrary.simpleMessage("CLOSE"),
    "delete": MessageLookupByLibrary.simpleMessage("DELETE"),
    "deleteAll": MessageLookupByLibrary.simpleMessage("DELETE ALL"),
    "deletePermanently": MessageLookupByLibrary.simpleMessage(
      "Permanently delete",
    ),
    "doDeletePermanently": m5,
    "doEmptyTrash": MessageLookupByLibrary.simpleMessage(
      "Do you want to empty the trash?",
    ),
    "done": MessageLookupByLibrary.simpleMessage("DONE"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editTag": MessageLookupByLibrary.simpleMessage("Edit tag"),
    "emptyScriptDeleted": MessageLookupByLibrary.simpleMessage(
      "Deleted an empty script.",
    ),
    "error": m6,
    "formatOrientation": MessageLookupByLibrary.simpleMessage(
      "Format orientation",
    ),
    "hide": MessageLookupByLibrary.simpleMessage("Hide"),
    "hint": MessageLookupByLibrary.simpleMessage("HINT"),
    "hintContent": MessageLookupByLibrary.simpleMessage(
      "If you don\'t want to play a sound during playback.",
    ),
    "horizontal": MessageLookupByLibrary.simpleMessage("Horizontal"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Invalid backup file",
    ),
    "lastModified": MessageLookupByLibrary.simpleMessage("Last modified"),
    "manualScroll": MessageLookupByLibrary.simpleMessage("Manual scroll"),
    "manualScrollDescription": MessageLookupByLibrary.simpleMessage(
      "Does not scroll automatically.",
    ),
    "micBusy": MessageLookupByLibrary.simpleMessage("The microphone is busy."),
    "moveTrash": MessageLookupByLibrary.simpleMessage("Move to trash"),
    "networkError": MessageLookupByLibrary.simpleMessage(
      "A network error has occurred.",
    ),
    "newTagAdded": MessageLookupByLibrary.simpleMessage("Added a new tag."),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noAdditionalText": MessageLookupByLibrary.simpleMessage(
      "No additional text",
    ),
    "noScriptYet": MessageLookupByLibrary.simpleMessage(
      "There is no script yet",
    ),
    "noTitle": MessageLookupByLibrary.simpleMessage("No title"),
    "notShowAgain": MessageLookupByLibrary.simpleMessage("Don\'t show again."),
    "onboardingCustomize": MessageLookupByLibrary.simpleMessage(
      "Customize as you like",
    ),
    "onboardingCustomizeDescription": MessageLookupByLibrary.simpleMessage(
      "You can customize the orientation of the formatting (vertical or horizontal), the color of the text, the font size, etc.",
    ),
    "onboardingManageScript": MessageLookupByLibrary.simpleMessage(
      "Manage your script",
    ),
    "onboardingManageScriptDescription": MessageLookupByLibrary.simpleMessage(
      "Add, edit, and delete scripts. You can organize your created scripts by tagging them.",
    ),
    "onboardingPlayScript": MessageLookupByLibrary.simpleMessage(
      "Play the script",
    ),
    "onboardingPlayScriptDescription": MessageLookupByLibrary.simpleMessage(
      "You can play back your completed script. With speech recognition, you can see at a glance how far you have spoken.",
    ),
    "onboardingStart": MessageLookupByLibrary.simpleMessage("Start"),
    "onboardingWelcomePresc": MessageLookupByLibrary.simpleMessage(
      "Welcome to Presc",
    ),
    "onboardingWelcomePrescDescription": MessageLookupByLibrary.simpleMessage(
      "Presc is a script display application that can be used for presentations, lectures, speeches, etc.",
    ),
    "openSetting": MessageLookupByLibrary.simpleMessage("OPEN SETTINGS"),
    "ossLicence": MessageLookupByLibrary.simpleMessage("Open Source License"),
    "permanentlyDeleted": MessageLookupByLibrary.simpleMessage(
      "The script has been permanently deleted.",
    ),
    "placeholderContent": MessageLookupByLibrary.simpleMessage("Enter here"),
    "placeholderTagName": MessageLookupByLibrary.simpleMessage(
      "Enter a name here",
    ),
    "placeholderTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "playMode": MessageLookupByLibrary.simpleMessage("Play mode"),
    "playSetting": MessageLookupByLibrary.simpleMessage("Play Settings"),
    "playSpeed": MessageLookupByLibrary.simpleMessage("Play speed"),
    "presentationTime": m7,
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "remove": MessageLookupByLibrary.simpleMessage("REMOVE"),
    "removeSelectTags": m8,
    "removeTag": MessageLookupByLibrary.simpleMessage("Remove tag"),
    "requirePermission": MessageLookupByLibrary.simpleMessage(
      "Microphone permission is required for speech recognition.",
    ),
    "resetInitValue": MessageLookupByLibrary.simpleMessage("RESET"),
    "restore": MessageLookupByLibrary.simpleMessage("Restore"),
    "restoreBackupFailed": m9,
    "restoreManuscript": MessageLookupByLibrary.simpleMessage(
      "Restore Manuscript",
    ),
    "restoreManuscriptDescription": MessageLookupByLibrary.simpleMessage(
      "Restore manuscripts from backup file",
    ),
    "saveBackupFile": MessageLookupByLibrary.simpleMessage("Save Backup File"),
    "searchScript": MessageLookupByLibrary.simpleMessage("Search the script"),
    "selectTagsRemoved": m10,
    "sendFeedback": MessageLookupByLibrary.simpleMessage("Send feedback"),
    "setting": MessageLookupByLibrary.simpleMessage("Settings"),
    "show": MessageLookupByLibrary.simpleMessage("Show"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "speechRecognition": MessageLookupByLibrary.simpleMessage(
      "Speech recognition",
    ),
    "speechRecognitionDescription": MessageLookupByLibrary.simpleMessage(
      "Scrolls by the amount of speech recognized text.",
    ),
    "tag": MessageLookupByLibrary.simpleMessage("Tag"),
    "tagList": MessageLookupByLibrary.simpleMessage("Tags"),
    "tagRemoved": MessageLookupByLibrary.simpleMessage("Removed tag."),
    "tagUpdated": MessageLookupByLibrary.simpleMessage("Updated tag."),
    "time": m11,
    "trash": MessageLookupByLibrary.simpleMessage("Trash"),
    "trashEmptied": MessageLookupByLibrary.simpleMessage("Emptied the trash."),
    "trashEmpty": MessageLookupByLibrary.simpleMessage(
      "The trash can is empty",
    ),
    "trashHint": MessageLookupByLibrary.simpleMessage(
      "The contents of the trash will be completely removed after 7 days.",
    ),
    "trashMoved": MessageLookupByLibrary.simpleMessage("Moved to the trash."),
    "trashRestored": MessageLookupByLibrary.simpleMessage(
      "Restored from the trash.",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("UNDO"),
    "undoDoubleTap": MessageLookupByLibrary.simpleMessage("Double tap to undo"),
    "undoRedoButton": MessageLookupByLibrary.simpleMessage("Undo/Redo button"),
    "vertical": MessageLookupByLibrary.simpleMessage("Vertical"),
  };
}
