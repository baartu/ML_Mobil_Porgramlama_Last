import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ekranlar/giris.dart';
import 'ekranlar/kayit.dart';
import 'ekranlar/bilgi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ekranlar/profil.dart';
import 'ekranlar/gecmisveriler.dart';
import 'ekranlar/sonuc.dart';
import 'ekranlar/splash_screen.dart';
import 'ekranlar/ayarlar.dart';
import 'package:provider/provider.dart';
import 'providers/font_size_provider.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx",
        appId: "1:123456789012:android:1234567890123456789012",
        messagingSenderId: "123456789012",
        projectId: "your-project-id",
      ),
    );
    runApp(
      ChangeNotifierProvider(
        create: (context) => FontSizeProvider(),
        child: const RunMyApp(),
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Firebase başlatılamazsa bile uygulamayı çalıştır
    runApp(
      ChangeNotifierProvider(
        create: (context) => FontSizeProvider(),
        child: const RunMyApp(),
      ),
    );
  }
}

class RunMyApp extends StatelessWidget {
  const RunMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return MaterialApp(
      title: 'Heartify',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.blue[50],
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: fontSizeProvider.fontSize),
          bodyMedium: TextStyle(fontSize: fontSizeProvider.fontSize),
          titleLarge: TextStyle(fontSize: fontSizeProvider.fontSize + 4),
          titleMedium: TextStyle(fontSize: fontSizeProvider.fontSize + 2),
          labelLarge: TextStyle(fontSize: fontSizeProvider.fontSize),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[700],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: fontSizeProvider.fontSize + 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey[400]!),
          ),
          labelStyle: TextStyle(color: Colors.blueGrey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[700],
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController textyas = TextEditingController();
  TextEditingController textController4 = TextEditingController();
  TextEditingController textController5 = TextEditingController();
  TextEditingController textController8 = TextEditingController();

  String? selectedGender;
  CPValues? selectedcp;
  FBSValues? selectedfbs;
  String? selectedekg;
  String? selectedexang;
  String? selectedeslope;
  String? selectedca;
  String? selectedthal;
  String? selecteddep;

  Future<void> saveData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        final dataRef = FirebaseFirestore.instance
            .collection("data")
            .doc(uid)
            .collection("time")
            .doc();

        Map<String, dynamic> data = {
          'uid': uid,
          "yas": textyas.text,
          "dinlenmekanbasinci": textController4.text,
          "serumkolesterol": textController5.text,
          "maxkalphızı": textController8.text,
          "cinsiyet": selectedGender,
          "agritipi": selectedcp?.valueTR,
          "aclikkansekeri": selectedfbs?.index,
          "dinlenmeekg": selectedekg,
          "egzersizebaglianjina": selectedexang,
          "stsegmentegimi": selectedeslope,
          "floroskopi": selectedca,
          "talasemi": selectedthal,
          "stdepresyonu": selecteddep,
          "time": FieldValue.serverTimestamp()
        };

        await dataRef.set(data);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Veri başarıyla kaydedildi!'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Tamam',
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Veri kaydetme hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veri kaydedilirken bir hata oluştu: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void showBartuDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[200],
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Kapat"),
            ),
          ],
        );
      },
    );
  } //info için parametreli method

  @override
  void dispose() {
    textyas.dispose();
    textController4.dispose();
    textController5.dispose();
    textController8.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('KVH Risk Formu'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueGrey[700]!, Colors.blueGrey[900]!],
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        "assets/heartify1.png",
                        height: 60,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Heartify",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              if (user != null && user.uid.isNotEmpty)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildDrawerItem(
                        icon: Icons.person_2_outlined,
                        title: 'Kişisel Bilgiler',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilSayfasi()),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.history_outlined,
                        title: 'Geçmiş Verilerim',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GecmisVeriler()),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.info_outlined,
                        title: 'Genel Bilgilendirme',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BilgilendirmeSayfasi()),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.settings_outlined,
                        title: 'Ayarlar',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AyarlarSayfasi()),
                        ),
                      ),
                      Divider(color: Colors.blueGrey[200]),
                      _buildDrawerItem(
                        icon: Icons.exit_to_app_outlined,
                        title: 'Çıkış Yap',
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RunMyApp()),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (user == null || user.uid.isEmpty)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildDrawerItem(
                        icon: Icons.info_outlined,
                        title: 'Genel Bilgilendirme',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BilgilendirmeSayfasi()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF78909C), Color(0xFF546E7A)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF78909C).withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GirisSayfasi()),
                              ),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.login_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Giriş Yap",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF607D8B), Color(0xFF455A64)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF607D8B).withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const KayitSayfasi()),
                              ),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.person_add_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Kayıt Ol",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[50]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormSection(
                    title: "Kişisel Bilgiler",
                    children: [
                      _buildTextField(
                        controller: textyas,
                        label: "Yaşınızı Girin",
                        keyboardType: TextInputType.number,
                        icon: Icons.person_outline,
                        iconColor: Color(0xFF2196F3),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: selectedGender,
                        label: "Cinsiyet Seçin",
                        items: ["Erkek", "Kadın"],
                        onChanged: (value) =>
                            setState(() => selectedGender = value),
                        icon: Icons.people_outline,
                        iconColor: Color(0xFF2196F3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormSection(
                    title: "Sağlık Bilgileri",
                    children: [
                      _buildDropdownField(
                        value: selectedcp,
                        label: "Ağrı Tipini Seçin",
                        items: CPValues.values,
                        onChanged: (value) =>
                            setState(() => selectedcp = value),
                        icon: Icons.favorite_border,
                        iconColor: Color(0xFF9C27B0),
                        infoButton: () => showBartuDialog(
                          "Ağrı Tipi Türleri",
                          "🔍 **Ağrı Tipi Türleri ve Açıklamaları**\n\n"
                              "❤️ **Tipik Anjina**\n"
                              "• Göğüs ağrısı, genellikle eforla ortaya çıkar\n"
                              "• Dinlenmekle geçer\n"
                              "• Kalp hastalığının en yaygın belirtisidir\n\n"
                              "💔 **Atipik Anjina**\n"
                              "• Tipik anjinadan farklı belirtiler gösterir\n"
                              "• Bazen istirahat halindeyken görülebilir\n"
                              "• Daha az spesifik belirtiler içerir\n\n"
                              "🫀 **Anjine Dışı Ağrı**\n"
                              "• Göğüs ağrısının kalp kaynaklı olmadığı düşünülür\n"
                              "• Farklı nedenlerden kaynaklanabilir\n\n"
                              "⚪ **Asemptomatik**\n"
                              "• Belirgin bir göğüs ağrısı şikayeti yoktur\n"
                              "• Sessiz kalp hastalığı olabilir\n"
                              "• Düzenli kontrol önemlidir",
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: textController4,
                        label: "Dinlenme Kan Basıncını Girin",
                        keyboardType: TextInputType.number,
                        icon: Icons.speed,
                        iconColor: Color(0xFF9C27B0),
                        infoButton: () => showBartuDialog(
                          "Dinlenme Kan Basıncı",
                          "🫀 **Dinlenme Kan Basıncı Nedir?**\n\n"
                              "📊 **Normal Değerler**\n"
                              "• Normal: 120/80 mmHg ve altı\n"
                              "• Yüksek Normal: 120-129/80 mmHg\n"
                              "• Yüksek Tansiyon: 130/80 mmHg ve üzeri\n\n"
                              "⚠️ **Önemli Notlar**\n"
                              "• Dinlenme halindeyken ölçülmelidir\n"
                              "• En az 5 dakika dinlenme sonrası ölçüm yapılmalıdır\n"
                              "• Kafein ve sigara kullanımından kaçınılmalıdır\n\n"
                              "🔍 **Ölçüm Öncesi**\n"
                              "• Sakin bir ortamda olun\n"
                              "• Kolunuz kalp hizasında olmalı\n"
                              "• Doğru manşet boyutu kullanılmalı",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormSection(
                    title: "Laboratuvar Sonuçları",
                    children: [
                      _buildTextField(
                        controller: textController5,
                        label: "Serum Kolesterol Değerini Girin (mg/dl)",
                        keyboardType: TextInputType.number,
                        icon: Icons.bloodtype_outlined,
                        iconColor: Color(0xFF4CAF50),
                        infoButton: () => showBartuDialog(
                          "Serum Kolesterol Değeri",
                          "🩸 **Serum Kolesterol Değeri Nedir?**\n\n"
                              "📊 **Değer Aralıkları**\n"
                              "✅ **Normal**: < 200 mg/dl\n"
                              "⚠️ **Sınırda Yüksek**: 200-239 mg/dl\n"
                              "❌ **Yüksek**: 240+ mg/dl\n\n"
                              "🔍 **Önemli Bilgiler**\n"
                              "• Toplam kolesterol seviyesini gösterir\n"
                              "• Kalp hastalığı riskini değerlendirmede önemlidir\n"
                              "• Düzenli kontrol edilmelidir\n\n"
                              "💡 **Öneriler**\n"
                              "• Sağlıklı beslenme\n"
                              "• Düzenli egzersiz\n"
                              "• Sigaradan uzak durma\n"
                              "• Stres yönetimi",
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: selectedfbs,
                        label: "Açlık kan şekeri > 120 mg/dl",
                        items: FBSValues.values,
                        onChanged: (value) =>
                            setState(() => selectedfbs = value),
                        icon: Icons.monitor_heart_outlined,
                        iconColor: Color(0xFF4CAF50),
                        infoButton: () => showBartuDialog(
                          "Açlık Kan Şekeri (FBS)",
                          "🩸 **Açlık Kan Şekeri Nedir?**\n\n"
                              "📊 **Değer Aralıkları**\n"
                              "✅ **Normal**: < 100 mg/dl\n"
                              "⚠️ **Prediyabet**: 100-125 mg/dl\n"
                              "❌ **Diyabet**: 126 mg/dl ve üzeri\n\n"
                              "🔍 **Ölçüm Öncesi**\n"
                              "• En az 8 saat aç kalınmalı\n"
                              "• Su içilebilir\n"
                              "• İlaç kullanımı doktora danışılmalı\n\n"
                              "⚠️ **Önemli Not**\n"
                              "Bu seçenekte:\n"
                              "➡️ 1 = Açlık kan şekeri 120 mg/dl'nin ÜZERİNDE\n"
                              "➡️ 0 = Açlık kan şekeri 120 mg/dl'nin ALTINDA",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormSection(
                    title: "EKG ve Egzersiz Sonuçları",
                    children: [
                      _buildDropdownField(
                        value: selectedekg,
                        label: "Dinlenme EKG Sonucu",
                        items: [
                          "0 = Normal",
                          "1 = ST-T anormalliği",
                          "2 = Sol ventrikül hipertrofisi"
                        ],
                        onChanged: (value) =>
                            setState(() => selectedekg = value),
                        icon: Icons.favorite_border,
                        iconColor: Color(0xFF2196F3),
                        infoButton: () => showBartuDialog(
                          "Dinlenme EKG Sonucu",
                          "🫀 **Dinlenme EKG Sonucu Nedir?**\n\n"
                              "📊 **Sonuç Türleri**\n"
                              "✅ **0 = Normal**\n"
                              "• Kalpte anormal bir elektriksel aktivite yok\n"
                              "• Normal kalp ritmi\n\n"
                              "⚠️ **1 = ST-T Anormalliği**\n"
                              "• ST segmenti veya T dalgasında anormallikler\n"
                              "• Kalp hastalığı belirtisi olabilir\n"
                              "• Daha detaylı inceleme gerekebilir\n\n"
                              "❌ **2 = Sol Ventrikül Hipertrofisi**\n"
                              "• Kalbin sol ventrikülünde kalınlaşma\n"
                              "• Hipertansiyonla ilişkili olabilir\n"
                              "• Düzenli takip önemli",
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: textController8,
                        label: "Ulaşılan Maksimum Kalp Atış Hızı",
                        keyboardType: TextInputType.number,
                        icon: Icons.favorite,
                        iconColor: Color(0xFF2196F3),
                        infoButton: () => showBartuDialog(
                          "Maksimum Kalp Atış Hızı",
                          "🫀 **Maksimum Kalp Atış Hızı Nedir?**\n\n"
                              "📊 **Hesaplama**\n"
                              "• Formül: 220 - yaş\n"
                              "• Örnek: 40 yaş için 220 - 40 = 180 atım/dakika\n\n"
                              "🔍 **Önemli Bilgiler**\n"
                              "• Egzersiz sırasında ulaşılan en yüksek hız\n"
                              "• Kişiye özel değerler\n"
                              "• Kondisyon seviyesini gösterir\n\n"
                              "⚠️ **Dikkat Edilmesi Gerekenler**\n"
                              "• Yüksek değerler: Kalp stresi gösterebilir\n"
                              "• Düşük değerler: Kondisyon eksikliğine işaret edebilir\n"
                              "• Düzenli egzersiz ile geliştirilebilir",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormSection(
                    title: "Ek Test Sonuçları",
                    children: [
                      _buildDropdownField(
                        value: selectedexang,
                        label: "Egzersize Bağlı Anjina",
                        items: ["1 = Evet", "0 = Hayır"],
                        onChanged: (value) =>
                            setState(() => selectedexang = value),
                        icon: Icons.fitness_center,
                        iconColor: Color(0xFF9C27B0),
                        infoButton: () => showBartuDialog(
                          "Egzersize Bağlı Anjina",
                          "🫀 **Egzersize Bağlı Anjina Nedir?**\n\n"
                              "📊 **Belirtiler**\n"
                              "• Fiziksel aktivite sırasında göğüs ağrısı\n"
                              "• Göğüste baskı hissi\n"
                              "• Nefes darlığı\n\n"
                              "🔍 **Önemli Bilgiler**\n"
                              "⚠️ **1 = Evet**\n"
                              "• Egzersiz sırasında göğüs ağrısı var\n"
                              "• Koroner arter hastalığı belirtisi olabilir\n"
                              "• Doktor kontrolü önerilir\n\n"
                              "✅ **0 = Hayır**\n"
                              "• Egzersiz sırasında göğüs ağrısı yok\n"
                              "• Normal durum\n"
                              "• Düzenli kontrol önemli",
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: selecteddep,
                        label: "ST Depresyonu",
                        items: ["1 = Var", "0 = Yok"],
                        onChanged: (value) =>
                            setState(() => selecteddep = value),
                        icon: Icons.show_chart,
                        iconColor: Color(0xFF9C27B0),
                        infoButton: () => showBartuDialog(
                          "ST Depresyonu",
                          "🫀 **ST Depresyonu Nedir?**\n\n"
                              "📊 **Tanım**\n"
                              "• EKG'de ST segmentinin normalden düşük olması\n"
                              "• Kalp kasının oksijen ihtiyacının karşılanamadığını gösterir\n\n"
                              "🔍 **Sonuçlar**\n"
                              "⚠️ **Var**\n"
                              "• ST segmenti düşüktür\n"
                              "• Kalp hastalığı riski olabilir\n"
                              "• Miyokard iskemisi belirtisi\n\n"
                              "✅ **Yok**\n"
                              "• ST segmentinde anormallik yok\n"
                              "• Normal durum\n"
                              "• Düzenli kontrol önemli",
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: selectedeslope,
                        label: "ST Segment Eğimi",
                        items: [
                          "0 = Yukarı eğimli",
                          "1 = Düz",
                          "2 = Aşağı eğimli"
                        ],
                        onChanged: (value) =>
                            setState(() => selectedeslope = value),
                        icon: Icons.trending_up,
                        iconColor: Color(0xFF9C27B0),
                        infoButton: () => showBartuDialog(
                          "ST Segment Eğimi",
                          "🫀 **ST Segment Eğimi Nedir?**\n\n"
                              "📊 **Eğim Türleri**\n"
                              "✅ **0 = Yükselen**\n"
                              "• Normal durum\n"
                              "• Sağlıklı kalp fonksiyonu\n\n"
                              "⚠️ **1 = Düz**\n"
                              "• Orta risk\n"
                              "• Dikkatli takip gerekli\n\n"
                              "❌ **2 = Alçalan**\n"
                              "• Yüksek risk\n"
                              "• Detaylı inceleme gerekli",
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: selectedca,
                        label: "Floroskopi ile Görülen Ana Damar Sayısı",
                        items: ["0", "1", "2", "3"],
                        onChanged: (value) =>
                            setState(() => selectedca = value),
                        icon: Icons.visibility,
                        iconColor: Color(0xFF9C27B0),
                        infoButton: () => showBartuDialog(
                          "Floroskopi ile Görülen Ana Damar Sayısı",
                          "🫀 **Floroskopi ile Görülen Ana Damar Sayısı**\n\n"
                              "📊 **Değerler ve Anlamları**\n"
                              "✅ **0**\n"
                              "• Tıkanıklık yok\n"
                              "• Normal durum\n\n"
                              "⚠️ **1-2**\n"
                              "• Hafif-orta tıkanıklık\n"
                              "• Dikkatli takip gerekli\n\n"
                              "❌ **3**\n"
                              "• Ciddi tıkanıklık\n"
                              "• Acil müdahale gerekebilir",
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: selectedthal,
                        label: "Talasemi",
                        items: [
                          "0 = Hata",
                          "1 = Sabit Defekt",
                          "2 = Normal",
                          "3 = Geri Dönüşlü Defekt"
                        ],
                        onChanged: (value) =>
                            setState(() => selectedthal = value),
                        icon: Icons.bloodtype,
                        iconColor: Color(0xFF9C27B0),
                        infoButton: () => showBartuDialog(
                          "Talasemi",
                          "🫀 **Talasemi Nedir?**\n\n"
                              "📊 **Değerler ve Anlamları**\n"
                              "✅ **3 = Normal**\n"
                              "• Normal kan akışı\n"
                              "• Sağlıklı durum\n\n"
                              "⚠️ **6 = Sabit Hata**\n"
                              "• Kalıcı kan akışı sorunu\n"
                              "• Düzenli takip gerekli\n\n"
                              "❌ **7 = Tersinir Hata**\n"
                              "• Geçici kan akışı sorunu\n"
                              "• Stres testi ile değerlendirilmeli",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 50.0)),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2196F3).withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              saveData(); // Veriyi önce kaydet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SonucSayfasi(
                                    inputData: {
                                      "age": double.parse(textyas.text),
                                      "sex":
                                          selectedGender == "Erkek" ? 1.0 : 0.0,
                                      "cp": selectedcp?.index?.toDouble(),
                                      "trestbps":
                                          double.parse(textController4.text),
                                      "chol":
                                          double.parse(textController5.text),
                                      "fbs": selectedfbs?.index?.toDouble(),
                                      "restecg": double.parse(
                                          selectedekg?.split("=")[0] ?? "0"),
                                      "thalach":
                                          double.parse(textController8.text),
                                      "exang": double.parse(
                                          selectedexang?.split("=")[0] ?? "0"),
                                      "oldpeak":
                                          selecteddep == "Var" ? 1.0 : 0.0,
                                      "slope": double.parse(
                                          selectedeslope?.split("=")[0] ?? "0"),
                                      "ca": double.parse(selectedca ?? "0"),
                                      "thal": double.parse(
                                          selectedthal?.split("=")[0] ?? "0"),
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.analytics_outlined,
                              size: 24, color: Colors.white),
                          label: const Text(
                            "Risk Analizi Yap",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSizeProvider.fontSize + 2,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[700],
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required IconData icon,
    Color? iconColor,
    VoidCallback? infoButton,
  }) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: fontSizeProvider.fontSize),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bu alan zorunludur';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: fontSizeProvider.fontSize),
              prefixIcon: Icon(icon, color: iconColor ?? Colors.blueGrey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey[700]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ),
        if (infoButton != null)
          IconButton(
            icon: Icon(Icons.info_outline,
                color: iconColor ?? Colors.blueGrey[700]),
            onPressed: infoButton,
          ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required IconData icon,
    Color? iconColor,
    VoidCallback? infoButton,
  }) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<T>(
            value: value,
            isExpanded: true,
            style: TextStyle(
              fontSize: fontSizeProvider.fontSize,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: fontSizeProvider.fontSize,
                color: Colors.blueGrey[700],
              ),
              prefixIcon: Icon(icon, color: iconColor ?? Colors.blueGrey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey[700]!),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            items: items.map((T item) {
              String displayText = '';
              if (item is Enum) {
                displayText = (item as dynamic).valueTR ?? item.toString();
              } else if (item is String) {
                displayText = item;
              } else {
                displayText = item.toString();
              }

              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  displayText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSizeProvider.fontSize,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: (T? newValue) {
              if (newValue != null) {
                setState(() {
                  onChanged(newValue);
                });
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Bu alan zorunludur';
              }
              return null;
            },
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[700]),
            isDense: true,
            menuMaxHeight: 300,
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        if (infoButton != null)
          IconButton(
            icon: Icon(Icons.info_outline,
                color: iconColor ?? Colors.blueGrey[700]),
            onPressed: infoButton,
          ),
      ],
    );
  }
}

enum CPValues {
  tipikAnjina("Tipik Anjina"),
  atipikAnjina("Atipik Anjina"),
  anjineDisiAgri("Anjine Dışı Ağrı"),
  asemptomatik("Asemptomatik");

  final String valueTR;
  const CPValues(this.valueTR);

  @override
  String toString() => valueTR;
}

enum FBSValues {
  yanlis("0 (Yanlış)"),
  dogru("1 (Doğru)");

  final String valueTR;
  const FBSValues(this.valueTR);

  @override
  String toString() => valueTR;
}
