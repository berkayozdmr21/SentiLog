import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mood_viewmodel.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel'a bağlanıyoruz
    final vm = Provider.of<MoodViewModel>(context);
    
    // Verileri çekiyoruz ve en yeni olanı en üstte gösteriyoruz
    final entries = vm.allEntries.reversed.toList(); 
    
    // Ekranda gösterilecek emojiler
    final emojis = ["😄", "🙂", "😐", "😔", "😢"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Geçmiş Kayıtlar", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                "Henüz hiç kayıt yapmamışsın.\nAna sayfadan bir mood ekle!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                
                final int moodValue = entry['mood'] ?? 0;
                final String note = entry['note'] ?? "";
                final String date = entry['date'].toString().substring(0, 16);
                // KRİTİK: Fotoğraf yolunu Hive'dan alıyoruz
                final String? imagePath = entry['imagePath'];

                int displayEmojiIndex = 4 - moodValue;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.white.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  borderOnForeground: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: Text(
                          emojis[displayEmojiIndex], 
                          style: const TextStyle(fontSize: 35)
                        ),
                        title: Text(
                          note.isEmpty ? "Not eklenmemiş" : note,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            date, 
                            style: const TextStyle(color: Colors.grey, fontSize: 12)
                          ),
                        ),
                      ),
                      
                      // --- FOTOĞRAF GÖSTERİM ALANI ---
                      if (imagePath != null && imagePath.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(imagePath),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              // Fotoğraf dosyası telefondan silindiyse hata vermemesi için
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  color: Colors.grey.withOpacity(0.1),
                                  child: const Center(
                                    child: Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}