import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/clinic_repository.dart';
import 'screens/student_visit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = ClinicRepository();
  await repository.initialize();

  runApp(ClinicVisitApp(repository: repository));
}

class ClinicVisitApp extends StatelessWidget {
  const ClinicVisitApp({super.key, required this.repository});

  final ClinicRepository repository;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF2E6B5C));
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Clinic',
      theme: base.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF4F8F6),
        textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: scheme.onPrimary,
          ),
        ),
      ),
      home: StudentVisitScreen(repository: repository),
    );
  }
}