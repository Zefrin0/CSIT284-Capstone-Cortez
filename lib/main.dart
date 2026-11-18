import 'package:flutter/material.dart';

import 'screens/student_visit_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ClinicVisitApp());
}

class ClinicVisitApp extends StatelessWidget {
  const ClinicVisitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Clinic',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E6B5C)),
      ),
      home: const StudentVisitScreen(),
    );
  }
}
