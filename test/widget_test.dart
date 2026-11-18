import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_cortez/main.dart';

void main() {
  testWidgets('Student can open and submit the visit form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ClinicVisitApp());

    expect(find.text('Log a clinic visit'), findsOneWidget);
    await tester.enterText(
      find.bySemanticsLabel('Student name'),
      'Alex Morgan',
    );
    await tester.enterText(find.bySemanticsLabel('Student ID'), 'ST-2024-300');
    await tester.enterText(find.bySemanticsLabel('Symptom'), 'Sore throat');
    await tester.tap(find.text('Join clinic queue'));
    await tester.pump();

    expect(find.text('Visit added to the clinic queue'), findsOneWidget);
  });

  testWidgets('Hidden nurse view opens seeded queue', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ClinicVisitApp());

    await tester.tap(find.byTooltip('Nurse view'));
    await tester.pumpAndSettle();

    expect(find.text('Clinic queue'), findsOneWidget);
    expect(find.text('Mia Thompson'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.text('Mark attended').first);
    await tester.pump();

    expect(find.text('Attended'), findsOneWidget);
  });
}
