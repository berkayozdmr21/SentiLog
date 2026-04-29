import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mindtrack_ai/main.dart';
import 'package:mindtrack_ai/viewmodels/mood_viewmodel.dart';

void main() {
  testWidgets('Uygulama açılış testi', (WidgetTester tester) async {
    // Uygulamayı başlat (Provider ile sarmalayarak)
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => MoodViewModel(),
        child: const MindTrackApp(),
      ),
    );

    // Uygulama başlığının ekranda olup olmadığını kontrol et
    expect(find.text('MindTrack AI'), findsOneWidget);

    // Ekranda emojilerin listelendiğini doğrula (Örn: Gülen yüz)
    expect(find.text('😄'), findsOneWidget);
  });
}