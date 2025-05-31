import 'package:deneme/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Lottie animasyonu için paket

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // 3 saniye sonra ana sayfaya yönlendirme
  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    // Ana sayfaya geçiş
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MyCustomForm(), // Ana sayfanızı burada tanımlayın
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800], // Arka plan rengi
      body: Center(
        child: Lottie.asset(
          'assets/Animation.json', // Animasyon dosyanızın yolu
          width: 250, // Genişlik
          height: 250, // Yükseklik
          fit: BoxFit.fill, // Animasyonun boyutlandırılması
        ),
      ),
    );
  }
}
