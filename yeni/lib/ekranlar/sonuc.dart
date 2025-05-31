import 'package:flutter/material.dart';
import 'package:deneme/services/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SonucSayfasi extends StatefulWidget {
  final Map<String, dynamic> inputData;

  const SonucSayfasi({Key? key, required this.inputData}) : super(key: key);

  @override
  _SonucSayfasiState createState() => _SonucSayfasiState();
}

class _SonucSayfasiState extends State<SonucSayfasi> {
  int? prediction;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrediction();
  }

  Future<void> _fetchPrediction() async {
    try {
      ApiService apiService = ApiService();
      // 10 saniye timeout ekliyoruz
      int? result = await apiService
          .predictHeartDisease(widget.inputData)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        print("API isteği zaman aşımına uğradı");
        return null;
      });

      print("API Cevabı: $result");

      if (mounted) {
        setState(() {
          prediction = result;
          isLoading = false;
        });
      }

      if (result != null) {
        await _kaydetGecmisi(result);
      }
    } catch (e) {
      print("Tahmin alınırken hata oluştu: $e");
      if (mounted) {
        setState(() {
          prediction = null;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _kaydetGecmisi(int sonuc) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('kullanicilar')
            .doc(user.uid)
            .collection('gecmis_sonuclar')
            .add({
          'tarih': Timestamp.now(),
          'veri': widget.inputData,
          'tahmin': sonuc,
        });
        print("Veri Firestore'a kaydedildi.");
      } else {
        print("Kullanıcı oturumu açık değil.");
      }
    } catch (e) {
      print("Firestore'a veri kaydedilirken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tahmin Sonucu'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade100, Colors.white],
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                )
              : prediction != null
                  ? _buildResultCard()
                  : _buildErrorCard(),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    bool isHighRisk = prediction == 1;
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isHighRisk
                  ? [Colors.red.shade50, Colors.red.shade100]
                  : [Colors.green.shade50, Colors.green.shade100],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isHighRisk ? Colors.red : Colors.green)
                            .withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    isHighRisk
                        ? Icons.warning_rounded
                        : Icons.check_circle_rounded,
                    color: isHighRisk ? Colors.red : Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isHighRisk
                      ? "Kalp Hastalığı Riski Yüksek!"
                      : "Kalp Hastalığı Riski Düşük!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isHighRisk
                        ? Colors.red.shade900
                        : Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isHighRisk
                        ? "Doktorunuza danışmanız önerilir."
                        : "Her şey yolunda görünüyor! Sağlıklı yaşamaya devam edin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isHighRisk
                          ? Colors.red.shade800
                          : Colors.green.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHighRisk
                          ? Colors.red.shade200
                          : Colors.green.shade200,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHighRisk
                            ? "Öneriler:"
                            : "Sağlıklı Yaşam İçin Öneriler:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isHighRisk
                              ? Colors.red.shade900
                              : Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isHighRisk) ...[
                        _buildRecommendationItem(
                          "1. En kısa sürede bir kardiyoloji uzmanına başvurun",
                          Icons.medical_services,
                          Colors.red,
                        ),
                        _buildRecommendationItem(
                          "2. Düzenli egzersiz yapın (doktorunuza danışarak)",
                          Icons.fitness_center,
                          Colors.red,
                        ),
                        _buildRecommendationItem(
                          "3. Tuz ve yağ tüketimini azaltın",
                          Icons.no_meals,
                          Colors.red,
                        ),
                        _buildRecommendationItem(
                          "4. Sigara ve alkol kullanımını bırakın",
                          Icons.smoke_free,
                          Colors.red,
                        ),
                        _buildRecommendationItem(
                          "5. Stres yönetimi için destek alın",
                          Icons.psychology,
                          Colors.red,
                        ),
                      ] else ...[
                        _buildRecommendationItem(
                          "1. Düzenli check-up yaptırın",
                          Icons.health_and_safety,
                          Colors.green,
                        ),
                        _buildRecommendationItem(
                          "2. Haftada en az 3 gün 30 dakika yürüyüş yapın",
                          Icons.directions_walk,
                          Colors.green,
                        ),
                        _buildRecommendationItem(
                          "3. Akdeniz tipi beslenmeye özen gösterin",
                          Icons.restaurant,
                          Colors.green,
                        ),
                        _buildRecommendationItem(
                          "4. Günde en az 2 litre su için",
                          Icons.water_drop,
                          Colors.green,
                        ),
                        _buildRecommendationItem(
                          "5. Uyku düzeninize dikkat edin",
                          Icons.bedtime,
                          Colors.green,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Tekrar Test Yap"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isHighRisk ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade50, Colors.grey.shade100],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.error_outline,
                    color: Colors.grey, size: 50),
              ),
              const SizedBox(height: 20),
              const Text(
                "Tahmin alınamadı!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Bir sorun oluştu. Lütfen internet bağlantınızı kontrol edin ve biraz sonra tekrar deneyin. Sorun devam ederse uygulamayı yeniden başlatmayı deneyebilirsiniz.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text("Tekrar Dene"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
