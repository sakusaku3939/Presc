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
    "addedNewTag" : MessageLookupByLibrary.simpleMessage("Added a new tag"),
    "cancel" : MessageLookupByLibrary.simpleMessage("cancel"),
    "change" : MessageLookupByLibrary.simpleMessage("change"),
    "changeTagName" : MessageLookupByLibrary.simpleMessage("change tag name"),
    "close" : MessageLookupByLibrary.simpleMessage("close"),
    "deleteAll" : MessageLookupByLibrary.simpleMessage("delete all"),
    "edit" : MessageLookupByLibrary.simpleMessage("edit"),
    "editTag" : MessageLookupByLibrary.simpleMessage("Edit tag"),
    "emptiedTrash" : MessageLookupByLibrary.simpleMessage("Emptied the trash."),
    "estimatedReadingTime" : MessageLookupByLibrary.simpleMessage("Estimated presentation time (300 characters per minute)"),
    "isEmptyTrash" : MessageLookupByLibrary.simpleMessage("Do you want to empty the trash?"),
    "lastModified" : MessageLookupByLibrary.simpleMessage("Last modified"),
    "moveTrash" : MessageLookupByLibrary.simpleMessage("Move to trash"),
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
    "remove" : MessageLookupByLibrary.simpleMessage("remove"),
    "removeTag" : MessageLookupByLibrary.simpleMessage("Remove tag"),
    "removeTagAlert" : m0,
    "removeTags" : m1,
    "removeTagsAlert" : MessageLookupByLibrary.simpleMessage("Do you want to remove all selected tags? This operation cannot be undone."),
    "restore" : MessageLookupByLibrary.simpleMessage("Restore"),
    "searchScript" : MessageLookupByLibrary.simpleMessage("Search the script"),
    "setting" : MessageLookupByLibrary.simpleMessage("setting"),
    "skip" : MessageLookupByLibrary.simpleMessage("Skip"),
    "tag" : MessageLookupByLibrary.simpleMessage("tag"),
    "tagList" : MessageLookupByLibrary.simpleMessage("Tag list"),
    "tagRemoved" : MessageLookupByLibrary.simpleMessage("Removed tag."),
    "tagsRemoved" : m2,
    "time" : m3,
    "trash" : MessageLookupByLibrary.simpleMessage("trash"),
    "trashEmpty" : MessageLookupByLibrary.simpleMessage("The trash can is empty"),
    "trashHint" : MessageLookupByLibrary.simpleMessage("The contents of the trash will be completely removed after 7 days."),
    "updatedTags" : MessageLookupByLibrary.simpleMessage("Updated tags"),
    "wordCount" : MessageLookupByLibrary.simpleMessage("Number of characters")
  };
}
