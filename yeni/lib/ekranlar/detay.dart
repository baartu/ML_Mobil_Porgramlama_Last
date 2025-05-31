import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetaySayfasi extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> veriler;
  final String tarih;

  const DetaySayfasi({
    super.key,
    required this.veriler,
    required this.tarih,
  });

  @override
  State<DetaySayfasi> createState() => _DetaySayfasiState();
}

class _DetaySayfasiState extends State<DetaySayfasi> {
  String? tahminDurumu;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Veri Detayları"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Yaş", widget.veriler["yas"]),
                      const Divider(),
                      _buildInfoRow("Cinsiyet", widget.veriler["cinsiyet"]),
                      const Divider(),
                      _buildInfoRow("Ağrı Tipi", widget.veriler["agritipi"]),
                      const Divider(),
                      _buildInfoRow("Dinlenme Kan Basıncı",
                          widget.veriler["dinlenmekanbasinci"]),
                      const Divider(),
                      _buildInfoRow("Serum Kolesterol Değeri",
                          widget.veriler["serumkolesterol"]),
                      const Divider(),
                      _buildInfoRow(
                          "Açlık Kan Şekeri", widget.veriler["aclikkansekeri"]),
                      const Divider(),
                      _buildInfoRow(
                          "Dinlenme EKG Sonucu", widget.veriler["dinlenmeekg"]),
                      const Divider(),
                      _buildInfoRow("Ulaşılan Maksimum Kalp Atış Hızı",
                          widget.veriler["maxkalphızı"]),
                      const Divider(),
                      _buildInfoRow("Egzersize Bağlı Anjina",
                          widget.veriler["egzersizebaglianjina"]),
                      const Divider(),
                      _buildInfoRow(
                          "ST Depresyonu", widget.veriler["stdepresyonu"]),
                      const Divider(),
                      _buildInfoRow(
                          "ST Segment Eğimi", widget.veriler["stsegmentegimi"]),
                      const Divider(),
                      _buildInfoRow(
                          "Floroskopi Değeri", widget.veriler["floroskopi"]),
                      const Divider(),
                      _buildInfoRow(
                          "Talasemi Durumu", widget.veriler["talasemi"]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.arrow_right, size: 24, color: Colors.blueGrey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
