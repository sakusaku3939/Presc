import 'package:flutter_test/flutter_test.dart';
import 'package:presc/features/playback/ui/providers/playback_timer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'totalSecond': 30});
  });

  for (final seconds in [65, 600]) {
    testWidgets('reset saves all $seconds elapsed seconds', (tester) async {
      final timer = PlaybackTimerProvider();
      addTearDown(timer.dispose);
      timer.start();
      await tester.pump(Duration(seconds: seconds));

      await timer.reset();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('totalSecond'), 30 + seconds);
      expect(timer.time, '00:00');

      await tester.pump(const Duration(seconds: 5));
      expect(timer.time, '00:00');
      await timer.reset();
      expect(prefs.getInt('totalSecond'), 30 + seconds);
    });
  }

  testWidgets('reset accumulates separate playback sessions', (tester) async {
    final timer = PlaybackTimerProvider();
    addTearDown(timer.dispose);

    timer.start();
    await tester.pump(const Duration(minutes: 5));
    await timer.reset();
    timer.start();
    await tester.pump(const Duration(minutes: 5));
    await timer.reset();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('totalSecond'), 630);
  });
}
