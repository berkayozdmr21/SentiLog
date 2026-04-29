import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("Berkay Özdemir"),
              subtitle: Text("MindTrack Kullanıcısı"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Tüm Verileri Sil", style: TextStyle(color: Colors.red)),
              onTap: () async {
                var box = Hive.box('moodBox');
                await box.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tüm geçmiş silindi.")),
                );
              },
            ),
            const Spacer(),
            const Text("Sürüm 1.0.0", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}