import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mood_viewmodel.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _musicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hoş Geldin!")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Icon(Icons.face, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text("Seni Tanıyalım", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Sana özel tavsiyeler hazırlayabilmemiz için:", textAlign: TextAlign.center),
            const SizedBox(height: 30),
            TextField(controller: _jobController, decoration: const InputDecoration(labelText: "Mesleğin / Okulun", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _hobbyController, decoration: const InputDecoration(labelText: "Hobilerin", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _musicController, decoration: const InputDecoration(labelText: "Sevdiğin Müzik Türleri", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_jobController.text.isNotEmpty) {
                    Provider.of<MoodViewModel>(context, listen: false)
                        .saveProfile(_jobController.text, _hobbyController.text, _musicController.text);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                  }
                },
                child: const Text("BAŞLAYALIM"),
              ),
            )
          ],
        ),
      ),
    );
  }
}