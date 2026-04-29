import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mood_viewmodel.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MoodViewModel>(context);
    final entries = vm.allEntries;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood İstatistikleri"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Duygu Durum Trendi",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Son kayıtlarına göre ruh hali değişimlerin:",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            // GRAFİK ALANI
            AspectRatio(
              aspectRatio: 1.5,
              child: entries.isEmpty 
                ? const Center(child: Text("Grafik için henüz veri yok."))
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      // Eksenlerdeki Emoji Ayarları
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              // Y eksenindeki değerlere göre emoji gösterimi
                              switch (value.toInt()) {
                                case 4: return const Text("😄", style: TextStyle(fontSize: 20));
                                case 2: return const Text("😐", style: TextStyle(fontSize: 20));
                                case 0: return const Text("😢", style: TextStyle(fontSize: 20));
                                default: return const Text("");
                              }
                            },
                          ),
                        ),
                        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(
                        show: true, 
                        border: const Border(bottom: BorderSide(color: Colors.white24), left: BorderSide(color: Colors.white24))
                      ),
                      minY: 0,
                      maxY: 4,
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(entries.length, (index) {
                            return FlSpot(index.toDouble(), entries[index]['mood'].toDouble());
                          }),
                          isCurved: true,
                          color: Colors.blueAccent,
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blueAccent.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
            
            const SizedBox(height: 50),
            
            // Bilgilendirme Kartı
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Grafik yukarı çıktıkça daha pozitif, aşağı indikçe daha düşük modda olduğun günleri gösterir.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}