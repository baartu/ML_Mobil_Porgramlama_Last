import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  final String baseUrl = "http://192.168.235.65:8080";
  double _safeParse(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      print("Uyarı: Boş veya null değer bulundu, 0.0 olarak ayarlandı.");
      return 0.0;
    }

    try {
      if (value is double) return value;
      return double.parse(value.toString().trim());
    } catch (e) {
      print(
          "Hata: '$value' değeri double'a çevrilemedi, 0.0 olarak ayarlandı.");
      return 0.0;
    }
  }

  double _extractNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      print("Uyarı: Boş veya null değer bulundu, 0.0 olarak ayarlandı.");
      return 0.0;
    }

    try {
      // Eğer değer zaten bir sayı ise direkt dön
      if (double.tryParse(value.trim()) != null) {
        return double.parse(value.trim());
      }

      // Sayıyı yakalamak için RegExp kullanıyoruz
      final match = RegExp(r'^\d+').firstMatch(value.trim());
      if (match != null) {
        return double.parse(match.group(0)!);
      } else {
        print(
            "Hata: '$value' değeri double'a çevrilemedi, 0.0 olarak ayarlandı.");
        return 0.0;
      }
    } catch (e) {
      print(
          "Hata: '$value' değeri işlenirken hata oluştu, 0.0 olarak ayarlandı.");
      return 0.0;
    }
  }

  Future<int?> predictHeartDisease(Map<String, dynamic> inputData) async {
    try {
      // İnternet bağlantısını kontrol et
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print("Hata: İnternet bağlantısı bulunamadı!");
        return -1; // İnternet bağlantısı yok
      }

      final uri = Uri.parse('$baseUrl/predict');

      // ✅ Debug için verileri kontrol edelim
      print("Gelen inputData: $inputData");

      Map<String, dynamic> cleanedData = {
        "age": _safeParse(inputData["age"]),
        "sex": inputData["sex"] == "Erkek" ? 1.0 : 0.0,
        "cp": _safeParse(inputData["cp"]),
        "trestbps": _safeParse(inputData["trestbps"]),
        "chol": _safeParse(inputData["chol"]),
        "fbs": inputData["fbs"] != null &&
                inputData["fbs"].toString().contains("1")
            ? 1.0
            : 0.0,
        "restecg": _safeParse(inputData["restecg"]),
        "thalach": _safeParse(inputData["thalach"]),
        "exang": inputData["exang"] != null &&
                inputData["exang"].toString().contains("1")
            ? 1.0
            : 0.0,
        "oldpeak": _safeParse(inputData["oldpeak"]),
        "slope": _safeParse(inputData["slope"]),
        "ca": _safeParse(inputData["ca"]),
        "thal": _safeParse(inputData["thal"]),
      };

      // ✅ JSON formatını kontrol edelim
      print("Gönderilen JSON: ${jsonEncode(cleanedData)}");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(cleanedData),
      );

      if (response.statusCode == 200) {
        print("API Yanıtı (Ham): ${response.body}");
        final jsonResponse = jsonDecode(response.body);
        print("API Yanıtı (JSON): $jsonResponse");
        print("Prediction değeri: ${jsonResponse["prediction"]}");
        return jsonResponse["prediction"];
      } else {
        print("Hata: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Hata oluştu: $e");
      return null;
    }
  }
}
