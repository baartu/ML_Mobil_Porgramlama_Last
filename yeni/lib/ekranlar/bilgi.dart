import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/font_size_provider.dart';

class BilgilendirmeSayfasi extends StatelessWidget {
  const BilgilendirmeSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilgilendirme'),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade100,
              Colors.blueGrey.shade50,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoCard(
              "Ağrı Tipi (Atipik Anjina)",
              "Atipik anjina, genellikle istirahat halinde veya normal aktiviteler sırasında ortaya çıkan göğüs ağrısıdır. "
                  "Bu ağrı, tipik anjina ile benzer semptomlar gösterse de, eforla değil, bazen dinlenme sırasında da görülebilir.",
              context,
            ),
            _buildInfoCard(
              "Ağrı Tipi (Tipik Anjina)",
              "Tipik anjina, efor sırasında veya stres altında ortaya çıkan, göğüs kafesinde sıkışma ve baskı hissi ile kendini gösterir. "
                  "Dinlenme ile ağrı genellikle geçer.",
              context,
            ),
            _buildInfoCard(
              "Ağrı Tipi (Anjine Dışı Ağrı)",
              "Anjine dışı ağrı, kalp hastalıkları ile doğrudan ilişkili olmayan göğüs ağrılarını ifade eder. "
                  "Genellikle kas-iskelet sisteminden veya mide problemlerinden kaynaklanabilir.",
              context,
            ),
            _buildInfoCard(
              "Ağrı Tipi (Asemptomatik)",
              "Asemptomatik, hastanın belirgin bir ağrı hissetmeden kalp hastalıklarını taşımasıdır. "
                  "Bu, kalp hastalığının varlığına rağmen herhangi bir belirti göstermeyen kişileri tanımlar.",
              context,
            ),
            _buildInfoCard(
              "Egzersize Bağlı Anjina",
              "Egzersize bağlı anjina, fiziksel aktivite veya egzersiz sırasında ortaya çıkan göğüs ağrısını ifade eder. "
                  "Bu ağrı genellikle kalp kasının oksijen ihtiyacının artması ile bağlantılıdır ve egzersiz bitiminde genellikle geçer. "
                  "Egzersizle ilgili yapılan testlerde sıklıkla görülür ve genellikle kalp hastalıklarının erken belirtisi olabilir.",
              context,
            ),
            _buildInfoCard(
              "ST Depresyonu",
              "ST depresyonu, EKG (elektrokardiyogram) üzerinde görülen bir durumdur ve kalbin elektriksel aktivitesindeki anormallikleri işaret eder. "
                  "Bu, genellikle kalp krizi, kalp hastalıkları veya damar tıkanıklığı gibi ciddi sağlık sorunlarının belirtisi olabilir. "
                  "ST depresyonu, kalbin oksijen ihtiyacının arttığı durumlarda, örneğin egzersiz sırasında, ST segmentinin normalden daha düşük bir seviyeye inmesiyle meydana gelir.",
              context,
            ),
            _buildInfoCard(
              "ST Segment Eğimi",
              "ST segment eğimi, kalbin elektriksel aktivitesini ölçen EKG testinde görülen bir durumdur ve kalp sağlığı hakkında önemli bilgiler sunar. "
                  "ST segmenti, EKG'nin bir parçasıdır ve genellikle kalp kasının yeniden polarize olduğu (uyarılma durumu) dönemi temsil eder. "
                  "ST segment eğimi, bu segmentin normalden daha yukarı, düz ya da aşağıda olmasını ifade eder. "
                  "Eğimin durumu, kalp sağlığı hakkında önemli ipuçları verebilir.",
              context,
            ),
            _buildInfoCard(
              "ST Segment Eğimi (Yukarı Eğimli)",
              "Yukarı eğimli ST segmenti, genellikle kalp krizi veya kalp damarlarında tıkanıklık belirtisi olabilir. "
                  "Bu durum, kalp kasının yeterli oksijen alamadığını ve ciddi bir sağlık sorunuyla karşı karşıya olabileceğini gösterir. "
                  "Yukarı eğimli ST segmenti, kalp krizi geçiren hastalarda sıkça görülür.",
              context,
            ),
            _buildInfoCard(
              "ST Segment Eğimi (Düz)",
              "Düz ST segmenti, normal bir EKG sonucudur ve genellikle sağlıklı bir kalp ile ilişkilendirilir. "
                  "Bu durum, kalbin elektriksel aktivitesinde herhangi bir anormallik olmadığını ve kalp kasının düzgün bir şekilde çalıştığını gösterir.",
              context,
            ),
            _buildInfoCard(
              "ST Segment Eğimi (Aşağı Eğimli)",
              "Aşağı eğimli ST segmenti, genellikle kalp damarlarında tıkanıklık veya koroner arter hastalığına işaret edebilir. "
                  "Bu durum, kalbin oksijen ihtiyacının arttığı ve yeterli oksijen almadığı anlamına gelir. "
                  "Aşağı eğimli ST segmenti, aynı zamanda kalp krizinin habercisi olabilir, ancak genellikle daha az belirgin bir durumdur.",
              context,
            ),
            _buildInfoCard(
              "Floroskopi ile Renklendirilen Büyük Damar Sayısı (0-3)",
              "Floroskopi, kalp damarlarının görüntülenmesini sağlayan bir testtir. "
                  "Bu test sırasında, damarların içine özel bir boya enjekte edilerek damarlar renklendirilir. "
                  "Böylece damarlar daha net bir şekilde görüntülenebilir ve kalpteki herhangi bir tıkanıklık, daralma veya hasar tespit edilebilir. "
                  "Floroskopi, genellikle koroner arter hastalığı gibi kalp hastalıklarının tanısında kullanılır.",
              context,
            ),
            _buildInfoCard(
              "Floroskopi (Hiçbir Damar Renklendirilmedi)",
              "0, floroskopi sırasında hiçbir damar renklendirilmediği anlamına gelir. "
                  "Bu durum, testin sonucunda herhangi bir damar tıkanıklığı veya daralması olmadığı gösterir. "
                  "Yani damarlar normal ve açık durumdadır, dolayısıyla kalp sağlığı açısından bir problem yoktur.",
              context,
            ),
            _buildInfoCard(
              "Floroskopi (Bir Damar Renklendirildi)",
              "1, floroskopi sırasında yalnızca bir damar renklendirildiğini gösterir. "
                  "Bu durumda, testin sonucunda yalnızca bir damar tıkanıklığı veya daralması saptanmış olabilir. "
                  "Bu damar, tedavi gerektirebilecek bir damar olabilir, ancak durum genellikle daha az ciddi olabilir.",
              context,
            ),
            _buildInfoCard(
              "Floroskopi (İki Damar Renklendirildi)",
              "2, floroskopi sırasında iki damar renklendirildiği anlamına gelir. "
                  "Bu durum, kalpteki iki damarda tıkanıklık veya daralma olduğunu gösterir. "
                  "Bu, daha ciddi bir durumu işaret edebilir ve tedavi gerektirebilir. "
                  "Bazı durumlarda, bu damarlar stent yerleştirilmesi veya başka bir cerrahi işlem gerektirebilir.",
              context,
            ),
            _buildInfoCard(
              "Floroskopi (Üç Damar Renklendirildi)",
              "3, floroskopi sırasında üç damar renklendirildiğini gösterir. "
                  "Bu durum, kalpte üç farklı damar tıkanıklığı veya daralması olduğunu gösterir ve genellikle ciddi bir durumu ifade eder. "
                  "Üç damar tıkanıklığı genellikle kalp krizi riskiyle ilişkilidir ve cerrahi müdahale (örneğin, bypass ameliyatı) gerektirebilir.",
              context,
            ),
            _buildInfoCard(
              "Talasemi Durumu",
              "Talasemi, kanın oksijen taşıma kapasitesini etkileyen genetik bir hastalıktır. "
                  "Talasemi, hemoglobin üretimiyle ilgili bir bozukluktan kaynaklanır. "
                  "Hemoglobin, kırmızı kan hücrelerinde bulunan ve oksijen taşıyan proteindir. Talasemide, bu protein ya hiç üretilemez ya da anormal şekilde üretilir.",
              context,
            ),
            _buildInfoCard(
              "Talasemi (Hata)",
              "0, talasemi durumunun yanlış veya hatalı olduğunu gösterir. Bu genellikle testin doğruluğuna veya veri girişine dayalı bir hatadır.",
              context,
            ),
            _buildInfoCard(
              "Talasemi (Sabit Defekt)",
              "1, sabit defektli bir talasemi durumunu ifade eder. Sabit defekt, genellikle daha hafif bir talasemi türünü ifade eder ve birey yaşamını normal bir şekilde sürdürebilir. Ancak bu kişiler, normalden daha düşük seviyede oksijen taşıyan kırmızı kan hücrelerine sahip olabilirler.",
              context,
            ),
            _buildInfoCard(
              "Talasemi (Normal)",
              "2, normal talasemi durumunu ifade eder. Bu durumda, bireyin hemoglobin üretimi sağlıklıdır ve herhangi bir hastalık belirtisi yoktur.",
              context,
            ),
            _buildInfoCard(
              "Talasemi Durumu (Geri Dönüşlü Defekt)",
              "3, geri dönüşlü defektli bir talasemi durumunu ifade eder. Bu, kişinin hemoglobin üretiminde geçici bir sorun olduğu anlamına gelir. Genellikle tedaviyle düzeltilebilir, ancak tedavi edilmediği takdirde kişide anemi (kan eksikliği) gibi belirtiler görülebilir.",
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_information_rounded,
                    color: Colors.blueGrey[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[800],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
