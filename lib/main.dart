import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/services/storage_service.dart';
import 'data/services/prayer_service.dart';
import 'data/services/quran_service.dart';
import 'data/services/audio_service.dart';
import 'features/ai_companion/islamic_ai_service.dart';
import 'features/layout/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final prayerService = PrayerService();
  // Fetch initial prayer times for current location (default Makkah/Lagos)
  prayerService.fetchPrayerTimes();

  final quranService = QuranService();
  quranService.fetchAllSurahs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: storageService),
        ChangeNotifierProvider.value(value: prayerService),
        ChangeNotifierProvider.value(value: quranService),
        ChangeNotifierProvider(create: (_) => AudioService()),
        ChangeNotifierProvider(create: (_) => IslamicAiService()),
      ],
      child: const MyIslamApp(),
    ),
  );
}

class MyIslamApp extends StatelessWidget {
  const MyIslamApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();

    return MaterialApp(
      title: 'MyIslam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storage.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainLayout(),
    );
  }
}
