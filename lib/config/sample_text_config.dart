import 'package:intl/intl.dart';

class SampleTextConfig {
  final _Locale _locale = Intl.getCurrentLocale() == "ja" ? _Ja() : _En();

  String get sampleTitle => _locale.sampleTitle;

  String get sampleContent => _locale.sampleContent;

  String get setting => _locale.setting;
}

abstract class _Locale {
  final String sampleTitle = "";
  final String sampleContent = "";
  final String setting = "";
}

class _Ja implements _Locale {
  final String sampleTitle = "吾輩は猫である";

  final String sampleContent = "吾輩は猫である。名前はまだ無い。\n"
      "どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。"
      "吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。"
      "この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。"
      "ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。\n"
      "\n"
      "掌の上で少し落ちついて書生の顔を見たのがいわゆる人間というものの見始であろう。この時妙なものだと思った感じが今でも残っている。"
      "第一毛をもって装飾されべきはずの顔がつるつるしてまるで薬缶だ。その後猫にもだいぶ逢ったがこんな片輪には一度も出会わした事がない。"
      "のみならず顔の真中があまりに突起している。そうしてその穴の中から時々ぷうぷうと煙を吹く。"
      "どうも咽せぽくて実に弱った。これが人間の飲む煙草というものである事はようやくこの頃知った。";

  final String setting = "吾輩は猫である。名前はまだ無い。\n"
      "どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。"
      "吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。";
}

class _En implements _Locale {
  final String sampleTitle = "iPhone 2007 - Steve Jobs";

  final String sampleContent =
      "The most advanced phones are called smart phones, so they say. "
      "And they typically combine a phone plus some e-mail capability, plus they say it’s the Internet.\n"
      "It’s sort of the baby Internet into one device, and they all have these little plastic keyboards on them. "
      "And the problem is that they’re not so smart and they’re not so easy to use, "
      "and so if you kind of make a Business School 101 graph of the smart axis and the easy-to-use axis, "
      "phones, regular cell phones are right there, they’re not so smart, and they’re not so easy to use.\n"
      "\n"
      "But smartphones are definitely a little smarter, but they actually are harder to use. "
      "They’re really complicated. Just for the basic stuff people have a hard time figuring out how to use them.\n"
      "Well, we don’t want to do either one of these things. "
      "What we want to do is make a leapfrog product that is way smarter than any mobile device has ever been and super-easy to use.\n"
      "This is what iPhone is.";

  final String setting =
      "The most advanced phones are called smart phones, so they say. "
      "And they typically combine a phone plus some e-mail capability, plus they say it’s the Internet.\n"
      "It’s sort of the baby Internet into one device, and they all have these little plastic keyboards on them. ";
}
