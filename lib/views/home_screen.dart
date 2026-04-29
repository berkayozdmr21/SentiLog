import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; 
import '../viewmodels/mood_viewmodel.dart';
import 'log_screen.dart';
import 'analytics_screen.dart';
import 'insights_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final pages = [
    const MoodPage(),
    const LogScreen(),
    const AnalyticsScreen(),
    const InsightsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, 
        elevation: 15,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: "Mood"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Geçmiş"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "İstatistik"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: "AI"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayar"),
        ],
      ),
    );
  }
}

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final TextEditingController _noteController = TextEditingController();
  File? _selectedImage; 

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fotoğraf erişim hatası: $e")),
      );
    }
  }

  void _showPickerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
              title: const Text('Galeriden Seç'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text('Anlık Fotoğraf Çek'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MoodViewModel>(context);
    final emojis = ["😄", "🙂", "😐", "😔", "😢"];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sentilog", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Bugün nasıl hissediyorsun?", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 25),
              
              // Emoji Listesi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(emojis.length, (i) {
                  return GestureDetector(
                    onTap: () {
                      vm.setMood(i);
                      FocusScope.of(context).unfocus();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: vm.selectedMood == i ? Colors.blueAccent.withOpacity(0.15) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: vm.selectedMood == i ? Colors.blueAccent : Colors.grey.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Text(emojis[i], style: const TextStyle(fontSize: 35)),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 35),
              
              TextField(
                controller: _noteController,
                maxLines: 4,
                autocorrect: false, 
                enableSuggestions: false,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "Günün nasıl geçti Berkay? Detaylandır...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey.withOpacity(0.08),
                ),
              ),
              
              const SizedBox(height: 30),

              const Text(
                "Günün karesiyle bu anı ölümsüzleştir...",
                style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _showPickerMenu(context);
                },
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: _selectedImage == null 
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, 
                               color: Colors.blueAccent.withOpacity(0.7), size: 50),
                          const SizedBox(height: 10),
                          const Text("Görsel Ekle", 
                               style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500)),
                        ],
                      )
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.file(_selectedImage!, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedImage = null),
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                radius: 15,
                                child: const Icon(Icons.close, size: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
              ),

              const SizedBox(height: 35),
              
              // --- GÜNCELLENEN KAYDET BUTONU ---
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (vm.selectedMood == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lütfen bir emoji seçin!")),
                      );
                    } else {
                      // CRITICAL: imagePath artık ViewModel'e gönderiliyor
                      vm.saveEntry(_noteController.text, _selectedImage?.path); 
                      
                      _noteController.clear();
                      setState(() => _selectedImage = null);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Sentilog gününüzü kaydetti! 🧠"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(double.infinity, 58),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text("GÜNÜ KAYDET", 
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}