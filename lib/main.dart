import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/mood_log.dart';
import 'models/activity_task.dart';
import 'models/daily_record.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {}

  await Hive.initFlutter();
  Hive.registerAdapter(MoodStatusAdapter());
  Hive.registerAdapter(MoodLogAdapter());
  Hive.registerAdapter(ActivityTaskAdapter());
  Hive.registerAdapter(DailyRecordAdapter());

  await Hive.openBox<MoodLog>('moods');
  await Hive.openBox<ActivityTask>('activities');
  await Hive.openBox<DailyRecord>('daily_records');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const VivereApp(),
    ),
  );
}

class VivereApp extends StatelessWidget {
  const VivereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B),
        primaryColor: const Color(0xFF6366F1),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFFEC4899),
          surface: Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
