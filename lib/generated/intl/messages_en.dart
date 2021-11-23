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

  static m1(count) => "Remove ${count} tags";

  static m2(count) => "${count} tags removed.";

  static m3(minutes, second) => "${minutes}m ${second}s";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addNewTag" : MessageLookupByLibrary.simpleMessage("Add new tag"),
    "alertRemoveSelectTags" : MessageLookupByLibrary.simpleMessage("Do you want to remove all selected tags? This operation cannot be undone."),
    "alertRemoveTag" : m0,
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "change" : MessageLookupByLibrary.simpleMessage("Change"),
    "changeTagName" : MessageLookupByLibrary.simpleMessage("Change tag name"),
    "characterCount" : MessageLookupByLibrary.simpleMessage("Number of characters"),
    "close" : MessageLookupByLibrary.simpleMessage("Close"),
    "deleteAll" : MessageLookupByLibrary.simpleMessage("Delete all"),
    "doEmptyTrash" : MessageLookupByLibrary.simpleMessage("Do you want to empty the trash?"),
    "edit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "editTag" : MessageLookupByLibrary.simpleMessage("Edit tag"),
    "estimatedReadingTime" : MessageLookupByLibrary.simpleMessage("Estimated presentation time (300 characters per minute)"),
    "lastModified" : MessageLookupByLibrary.simpleMessage("Last modified"),
    "moveTrash" : MessageLookupByLibrary.simpleMessage("Move to trash"),
    "newTagAdded" : MessageLookupByLibrary.simpleMessage("Added a new tag"),
    "next" : MessageLookupByLibrary.simpleMessage("Next"),
    "noAdditionalText" : MessageLookupByLibrary.simpleMessage("No additional text"),
    "noScriptYet" : MessageLookupByLibrary.simpleMessage("There is no script yet"),
    "noTitle" : MessageLookupByLibrary.simpleMessage("No title"),
    "onboardingCustomize" : MessageLookupByLibrary.simpleMessage("Customize as you like"),
    "onboardingCustomizeDescription" : MessageLookupByLibrary.simpleMessage("You can customize the orientation of the formatting (vertical or horizontal), the color of the text, the font size, etc."),
    "onboardingManageScript" : MessageLookupByLibrary.simpleMessage("Manage your script"),
    "onboardingManageScriptDescription" : MessageLookupByLibrary.simpleMessage("Add, edit, and delete scripts. You can organize your created scripts by tagging them."),
    "onboardingPlayScript" : MessageLookupByLibrary.simpleMessage("Play the script"),
    "onboardingPlayScriptDescription" : MessageLookupByLibrary.simpleMessage("You can play back your completed script. With speech recognition, you can see at a glance how far you have spoken."),
    "onboardingStart" : MessageLookupByLibrary.simpleMessage("Start"),
    "onboardingWelcomePresc" : MessageLookupByLibrary.simpleMessage("Welcome to Presc"),
    "onboardingWelcomePrescDescription" : MessageLookupByLibrary.simpleMessage("Presc is a script display application that can be used for presentations, lectures, speeches, etc."),
    "permanentlyDeleted" : MessageLookupByLibrary.simpleMessage("Permanently deleted"),
    "placeholderContent" : MessageLookupByLibrary.simpleMessage("Enter here"),
    "placeholderTagName" : MessageLookupByLibrary.simpleMessage("Enter a name here"),
    "placeholderTitle" : MessageLookupByLibrary.simpleMessage("Title"),
    "remove" : MessageLookupByLibrary.simpleMessage("Remove"),
    "removeSelectTags" : m1,
    "removeTag" : MessageLookupByLibrary.simpleMessage("Remove tag"),
    "restore" : MessageLookupByLibrary.simpleMessage("Restore"),
    "searchScript" : MessageLookupByLibrary.simpleMessage("Search the script"),
    "selectTagsRemoved" : m2,
    "setting" : MessageLookupByLibrary.simpleMessage("Settings"),
    "skip" : MessageLookupByLibrary.simpleMessage("Skip"),
    "tag" : MessageLookupByLibrary.simpleMessage("Tag"),
    "tagList" : MessageLookupByLibrary.simpleMessage("Tags"),
    "tagRemoved" : MessageLookupByLibrary.simpleMessage("Removed tag."),
    "tagUpdated" : MessageLookupByLibrary.simpleMessage("Updated tag"),
    "time" : m3,
    "trash" : MessageLookupByLibrary.simpleMessage("Trash"),
    "trashEmptied" : MessageLookupByLibrary.simpleMessage("Emptied the trash."),
    "trashEmpty" : MessageLookupByLibrary.simpleMessage("The trash can is empty"),
    "trashHint" : MessageLookupByLibrary.simpleMessage("The contents of the trash will be completely removed after 7 days.")
  };
}
