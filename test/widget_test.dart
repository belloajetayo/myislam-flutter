import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myislam_flutter/main.dart';
import 'package:myislam_flutter/data/services/storage_service.dart';
import 'package:myislam_flutter/data/services/prayer_service.dart';
import 'package:myislam_flutter/data/services/quran_service.dart';
import 'package:myislam_flutter/data/services/audio_service.dart';

void main() {
  testWidgets('MyIslam app smoke test', (WidgetTester tester) async {
    final storageService = StorageService();
    final prayerService = PrayerService();
    final quranService = QuranService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: storageService),
          ChangeNotifierProvider.value(value: prayerService),
          ChangeNotifierProvider.value(value: quranService),
          ChangeNotifierProvider(create: (_) => AudioService()),
        ],
        child: const MyIslamApp(),
      ),
    );

    // Verify MyIslam brand title is present
    expect(find.text('MyIslam'), findsWidgets);
  });
}
