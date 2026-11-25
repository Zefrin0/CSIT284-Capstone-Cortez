import 'package:capstone_cortez/main.dart';
import 'package:capstone_cortez/models/clinic_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('student can join the queue and nurse sees the visit', (
    tester,
  ) async {
    await tester.pumpWidget(ClinicVisitApp(repository: ClinicRepository()));

    expect(find.text('Demo mode'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Test Student');
    await tester.enterText(fields.at(1), 'ST-2024-999');
    await tester.enterText(fields.at(2), 'Headache');

    final submit = find.text('Join clinic queue');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nurse view'));
    await tester.pumpAndSettle();

    expect(find.text('Test Student'), findsOneWidget);
  });
}
