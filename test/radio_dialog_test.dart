import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presc/features/setting/ui/widgets/radio_dialog.dart';

void main() {
  testWidgets('radio dialog selects a value and closes', (tester) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () => RadioDialog.show(
                  context,
                  groupValue: 1,
                  itemList: [
                    RadioDialogItem(title: 'Manual', value: 1),
                    RadioDialogItem(title: 'Automatic', value: 2),
                  ],
                  onChanged: (value) => selected = value as int,
                ),
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final group = tester.widget<RadioGroup<dynamic>>(
      find.byType(RadioGroup<dynamic>),
    );
    expect(group.groupValue, 1);
    await tester.tap(find.text('Automatic'));
    await tester.pumpAndSettle();
    expect(selected, 2);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
