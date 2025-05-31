import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detay.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// 📌 Timestamp formatlama fonksiyonu
String formatTarih(dynamic timestamp) {
  initializeDateFormatting('tr_TR', null);
  if (timestamp is int) {
    DateTime tarih = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(tarih);
  } else if (timestamp is Timestamp) {
    DateTime tarih = timestamp.toDate();
    return DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(tarih);
  }
  return "Bilinmeyen Tarih";
}

class GecmisVeriler extends StatelessWidget {
  const GecmisVeriler({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        body: const Center(
          child: Text(
            "Kullanıcı girişi yapılmamış.",
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ),
      );
    }

    String uid = currentUser.uid;
    print("Kullanıcı ID: $uid"); // Debug için kullanıcı ID'sini yazdır

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Geçmiş Veriler",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('data')
            .doc(uid)
            .collection("time")
            .orderBy('time', descending: true)
            .limit(1000)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(
                "Firestore Hatası: ${snapshot.error}"); // Hata durumunu yazdır
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Veri çekilirken bir hata oluştu: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Sayfayı yenile
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GecmisVeriler(),
                        ),
                      );
                    },
                    child: const Text("Yeniden Dene"),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print(
                "Veri bulunamadı veya boş"); // Debug için veri durumunu yazdır
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Henüz geçmiş veriniz yok.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Sayfayı yenile
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GecmisVeriler(),
                        ),
                      );
                    },
                    child: const Text("Yenile"),
                  ),
                ],
              ),
            );
          }

          var veriler = snapshot.data!.docs;
          print(
              "Çekilen veri sayısı: ${veriler.length}"); // Debug için veri sayısını yazdır

          return ListView.builder(
            itemCount: veriler.length,
            itemBuilder: (context, index) {
              var veri = veriler[index];
              var timestamp = (veri.data() as Map<String, dynamic>?)?['time'];
              var tarih = formatTarih(timestamp);

              return Card(
                color: Colors.white,
                shadowColor: Colors.grey[300],
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    "Tarih: $tarih",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Colors.blueGrey,
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfasi(
                          veriler: veri,
                          tarih: tarih,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
