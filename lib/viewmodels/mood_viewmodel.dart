import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MoodViewModel extends ChangeNotifier {
  int selectedMood = -1;
  final Box _box = Hive.box('moodBox');

  // Kullanıcı profilini getirir
  Map? get userProfile => _box.get('profile');

  // Profili kaydeder
  void saveProfile(String job, String hobbies, String music) {
    _box.put('profile', {
      'job': job,
      'hobbies': hobbies,
      'music': music,
    });
    notifyListeners();
  }

  void setMood(int mood) {
    selectedMood = mood;
    notifyListeners();
  }

  // saveEntry fonksiyonuna imagePath parametresi eklendi
  void saveEntry(String note, String? imagePath) {
    if (selectedMood != -1) {
      int correctedValue = 4 - selectedMood;
      _box.add({
        'mood': correctedValue,
        'note': note,
        'date': DateTime.now().toString(),
        'imagePath': imagePath, // Fotoğraf yolunu Hive'a kaydediyoruz
      });
      selectedMood = -1;
      notifyListeners();
    }
  }

  // Sadece mood kayıtlarını filtreleyerek getirir
  List get allEntries => _box.values.where((e) => e is Map && e.containsKey('mood')).toList();
}