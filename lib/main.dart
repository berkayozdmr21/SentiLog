import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'viewmodels/mood_viewmodel.dart';
import 'views/home_screen.dart';
import 'views/onboarding_screen.dart'; // Yeni ekranı içe aktardık

void main() async {
  // 1. Hive Veritabanını başlat
  await Hive.initFlutter();
  await Hive.openBox('moodBox'); 

  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodViewModel(),
      child: const MindTrackApp(),
    ),
  );
}

class MindTrackApp extends StatelessWidget {
  const MindTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindTrack AI',
      theme: ThemeData.dark(),
      home: Consumer<MoodViewModel>(
        builder: (context, vm, child) {
          // EĞER profil boşsa OnboardingScreen'e, doluysa HomeScreen'e git
          return vm.userProfile == null 
              ? const OnboardingScreen() 
              : const HomeScreen();
        },
      ),
    );
  }
}