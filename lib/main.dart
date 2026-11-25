import 'package:flutter/material.dart';

import 'models/clinic_repository.dart';
import 'screens/student_visit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Falls back to demo mode automatically if Firebase is not configured.
  final repository = ClinicRepository();
  await repository.initialize();

  runApp(ClinicVisitApp(repository: repository));
}

class ClinicVisitApp extends StatelessWidget {
  const ClinicVisitApp({super.key, required this.repository});

  final ClinicRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Clinic',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E6B5C)),
      ),
      home: StudentVisitScreen(repository: repository),
    );
  }
}
