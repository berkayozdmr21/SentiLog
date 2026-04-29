import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mood_viewmodel.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MoodViewModel>(context);
    final entries = vm.allEntries;
    final profile = vm.userProfile;

    String generateSmartInsight() {
      if (entries.isEmpty) return "Seni tanımam için biraz daha not yazmalısın. ✨";

      final lastEntry = entries.last;
      final int mood = lastEntry['mood'] ?? 2;
      final String note = (lastEntry['note'] ?? "").toString().toLowerCase();
      final String job = profile?['job'] ?? "Yazılımcı";
      
      // --- VERİ HAZIRLAMA ---
      List<String> rawHobbies = (profile?['hobbies'] ?? "").toString().split(RegExp(r'[,.]+'));
      List<String> rawMusics = (profile?['music'] ?? "").toString().split(RegExp(r'[,.]+'));

      List<String> cleanHobbies = rawHobbies.map((e) => e.trim()).where((e) => e.length > 2).toList();
      List<String> cleanMusics = rawMusics.map((e) => e.trim()).where((e) => e.length > 2).toList();

      // --- AKILLI DIŞLAMA ---
      List<String> availableHobbies = cleanHobbies.where((h) => !note.contains(h.toLowerCase())).toList();
      
      String suggestedHobby = availableHobbies.isNotEmpty 
          ? availableHobbies[Random().nextInt(availableHobbies.length)] 
          : (cleanHobbies.isNotEmpty ? cleanHobbies[0] : "yeni bir aktivite");
          
      String music = cleanMusics.isNotEmpty 
          ? cleanMusics[Random().nextInt(cleanMusics.length)] 
          : "sevdiğin bir şarkı";

      // --- DİL BİLGİSİ DÜZELTME (Yeni Eklenen Kısım) ---
      // Hobinin sonundaki "mek/mak" ekini atıyoruz (Gezmek -> Gez)
      String hobiKoku = suggestedHobby.replaceAll(RegExp(r'(mek|mak)$', caseSensitive: false), "");
      
      // Kelimenin son sesli harfine göre ek belirleme (İnce/Kalın uyumu için basit kontrol)
      String ek = RegExp(r'[aıou]').hasMatch(hobiKoku.characters.last.toLowerCase()) ? "arak" : "erek";
      String hobiZarf = "$hobiKoku$ek"; // Örn: Gezerek, Okuyarak (Eğer son harf sesliyse 'y' koruması eklenebilir ama şu anki haliyle bile çok daha iyi)

      // --- AI MANTIK MOTORU (GÜNCEL DOĞAL CÜMLELER) ---

      if (mood >= 3) {
        if (RegExp(r'(alışveriş|aldım|etek|elbise|ayakkabı|çanta|harcadım)').hasMatch(note)) {
          return "Yeni aldığın cicilerin sana çok yakışacağına eminim, güle güle kullan! 🛍️ Bu güzel gününde biraz $hobiKoku ve mutluluğunu ikiye katla. Sonrasında da sevdiğin o $music şarkılarıyla günü huzurla tamamlayalım.";
        } 
        else if (RegExp(r'(kod|proje|başardım|çalıştı|sınav|mülakat|bitti)').hasMatch(note)) {
          return "Kodların tıkır tıkır çalışması veya bir işi bitirmek gibisi yok! 💻 Bir $job olarak bu başarını $hobiZarf kutlayarak enerjini zirveye taşıyalım. Arkada $music çalarken zaferin tadını çıkar.";
        }
        else if (RegExp(r'(maç|kazandık|gol|arkadaş|eğlendik|gezdik)').hasMatch(note)) {
          return "Harika bir gün geçirmişsin, enerjin buraya kadar geldi! 🌟 Şimdi biraz da $hobiKoku ve bu sosyal modu kişiselleştir. $music eşliğinde günün en güzel anlarını hatırla.";
        }
        else {
          return "Gününün güzel geçmesi beni de çok mutlu etti! ✨ Bu pozitif enerjiyi $hobiZarf korumaya ne dersin? Üstelik sevdiğin $music listeni dinlemek keyfini daha da arttıracaktır.";
        }
      }

      else if (mood <= 1) {
        if (RegExp(r'(maç|berabere|yenildik|takım|beşiktaş|skor)').hasMatch(note)) {
          return "Üzme kendini Berkay, skor can sıkıcı olsa da önümüzdeki maçları kazanırız! 💪 Gel şimdi kafanı dağıtmak için biraz $hobiKoku. Yanında sevdiğin $music eşlik ederse her şeyin daha hızlı düzeleceğine eminim.";
        }
        else if (RegExp(r'(hata|bug|çalışmadı|yorgun|debug|beynim|sınav|düşük)').hasMatch(note)) {
          return "Bazen sistem hata verir veya işler istediğimiz gibi gitmez. 🧘‍♂️ Bugün kendine biraz şefkat göster; biraz $hobiKoku ve zihnini dinlendir. Arkada $music çalması moralini yavaş yavaş yükseltecektir.";
        }
        else {
          return "Canını sıkan her neyse geçici olduğunu unutma Berkay. ☁️ Bugün kendine biraz şefkat göster. Biraz $hobiKoku ve zihnini dinlendir, sevdiğin $music ile modunu tazeleyelim.";
        }
      }

      return "Bugün her şey dengede görünüyor. ⚖️ Bu huzurlu modu bozmadan $hobiZarf ilgilenip sevdiğin $music listeni dinleyerek kendine küçük bir güzellik yapabilirsin.";
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Zeki AI Analiz", style: TextStyle(fontWeight: FontWeight.bold)), 
        centerTitle: true, 
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 60, color: Colors.blueAccent),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    generateSmartInsight(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, height: 1.6, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Cihaz Üstü Yapay Zeka Aktif", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}