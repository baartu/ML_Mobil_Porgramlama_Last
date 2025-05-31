# Kalp Hastalığı Risk Tahmini Mobil Karar Destek Sistemi

Bu depoda, kalp hastalığı riskini tahmin etmek üzere geliştirilmiş **makine öğrenimi tabanlı** bir mobil karar destek sistemi yer almaktadır. Proje kapsamında veriler Kaggle’daki “Heart Disease” veri setinden (303 örnek, 14 özellik) alınmış, dokuz farklı sınıflandırma algoritması kıyaslanmış ve nihai model olarak **Random Forest** seçilmiştir. Elde edilen model, bir mobil uygulamaya entegre edilerek kullanıcılara gerçek zamanlı risk tahmini imkanı sunmaktadır.

---

## İçindekiler

1. [Proje Hakkında](#proje-hakkında)  
2. [Motivasyon](#motivasyon)  
3. [Özellikler](#özellikler)  
4. [Veri Seti](#veri-seti)  
5. [Kullanılan Algoritmalar](#kullanılan-algoritmalar)
6. [Sonuçlar](#sonuclar) 
---

## Proje Hakkında

Bu proje, kalp hastalığı riskini öngörmek üzere geliştirilen bir makine öğrenimi uygulamasıdır. Hem veri bilimciler hem de sağlık profesyonelleri tarafından kullanılabilecek bir karar destek aracı oluşturmak amaçlanmıştır. Elde edilen model, bir mobil uygulamaya entegre edilerek:
- Kullanıcının girdiği tıbbi ve demografik parametrelere göre **anlık risk skoru** hesaplar,
- Yüksek risk taşıyan bireyleri uyarır ve gerekli önlemleri almalarını önerir,
- Tahmin sürecini **hızlı**, **güvenilir**, ve **yorumlanabilir** hale getirir.

---

## Motivasyon

- **Kalp hastalıkları**, dünya genelinde önde gelen ölüm nedenlerinden biridir.  
- Erken teşhis ve önleyici tedbirler ile yaşam kurtarmak mümkündür.  
- Makine öğrenimi temelli sistemler, hastalık riskini hızlı ve doğru şekilde tahmin ederek bireyleri zamanında sağlık kuruluşlarına yönlendirebilir.  
- Mevcut klinik uygulamaların birçoğu yalnızca sağlık profesyonellerine yönelik olup, son kullanıcıya (bireye) doğrudan erişim sağlamamaktadır. Bu projede, **mobil uygulama** üzerinden bireylere doğrudan rehberlik edecek bir sistem hedeflenmiştir.

---

## Özellikler

- **Dokuz farklı sınıflandırma algoritmasının karşılaştırılması** (ZeroR, OneR, Naive Bayes, J48, Çoklu Algılayıcılar, Destek Vektör Makinesi, Random Forest, Lojistik Regresyon, k-NN).   
- **Model eğitimi ve hiperparametre optimizasyonu**.  
- **Performans değerlendirme** (Accuracy, F₁-skor, Precision, Recall).  
- **Random Forest tabanlı nihai model** ile **mobil uygulamaya gerçek zamanlı entegrasyon**.  
- **Kullanıcı dostu arayüz (UI/UX) tasarımı** ve özel erişilebilirlik (büyük yazı vb.) özellikleri.  
- **TÜBİTAK destekli (Proje No: 1919B012429311)** bir araştırma projesi olarak yürütülmüştür.  

---

## Veri Seti

- Kaynak: [Kaggle – Heart Disease UCI Dataset](https://www.kaggle.com/ronitf/heart-disease-uci)  
- Toplam 303 örnek; 14 öznitelik + 1 hedef (Target).  
- Erkek: 207, Kadın: 96.  
- Riskli (Target = 1): 165 örnek; Risksiz (Target = 0): 138 örnek.  

| Öznitelik | Açıklama                                    | Değer / Birim                       |
|-----------|---------------------------------------------|-------------------------------------|
| Age       | Yaş                                         | Yıl                                 |
| Sex       | Cinsiyet                                    | 1 = Erkek, 0 = Kadın                |
| Cp        | Göğüs Ağrısı Tipi                           | 0 = Tipik Anjina, 1 = Atipik Anjina, 2 = Anjina Dışı Ağrı, 3 = Asemptomatik |
| Trestbps  | Dinlenme Kan Basıncı                        | Hastaneye kabulde ölçülen (mm Hg)   |
| Chol      | Serum Kolesterol                            | (mg/dl)                             |
| Fbs       | Açlık Kan Şekeri (> 120 mg/dl)              | 1 = Doğru, 0 = Yanlış               |
| Restecg   | Dinlenme EKG Sonucu                         | 0 = Normal, 1 = ST-T Anormalliği, 2 = Sol Ventrikül Hipertrofisi |
| Thalach   | Maksimum Kalp Atış Hızı                     | Ulaşılan en yüksek (bpm)            |
| Exang     | Egzersize Bağlı Anjina                      | 1 = Evet, 0 = Hayır                 |
| Oldpeak   | Egzersiz Sonrası ST Depresyonu              | ST Depresyonu (mm)                  |
| Slope     | ST Segment Eğimi                            | 0 = Yukarı Eğilimli, 1 = Düz, 2 = Aşağı Eğilimli |
| Ca        | Floroskopi ile renklendirilen büyük damar sayısı | 0–3                               |
| Thal      | Talasemi Durumu                             | 0 = Hata, 1 = Sabit Defekt, 2 = Normal, 3 = Geri Dönüşlü Defekt |
| Target    | Hastalık Durumu                             | 0 = Risk Yok, 1 = Risk Var          |

---

## Kullanılan Algoritmalar

1. **ZeroR**  
   - Özellik kullanmayan basit bir sınıflandırma algoritması.  
   - Alt eşik belirlemek (baseline) için referans sunar.  

2. **OneR**  
   - Her bir özelliğe dayalı basit tek-kural sınıflandırıcılar oluşturur.  
   - En yüksek doğruluğu sağlayan özelliği seçer.  

3. **Naive Bayes**  
   - Bayes teoremi ve özelliklerin birbirinden bağımsız olduğu varsayımına dayanır.  
   - Hem hesaplama açısından hafiftir hem de genellikle dengeli sonuçlar üretir.  

4. **J48 (C4.5) Karar Ağacı**  
   - Karar ağacı temelli, dallanma yapısı ile açık/yorumlanabilir sonuçlar sunar.  
   - Bilgi kazancı (information gain) kriteriyle bölümler oluşturur.  

5. **Çoklu Algılayıcılar (MLP Ensemble)**  
   - Birden fazla yapay sinir ağı modelini bir arada çalıştırarak toplu (ensemble) karar verir.  
   - Bagging/Boosting yöntemleriyle performansı güçlendirme potansiyeli vardır.  

6. **Destek Vektör Makinesi (SVM)**  
   - Veriyi ayıran en geniş marjlı hiper-düzlemi bulmaya çalışır.  
   - Kernel fonksiyonlarıyla doğrusal olmayan problem çözümüne uygundur.  

7. **Random Forest (Rastgele Orman)**  
   - Birden fazla karar ağacı oluşturarak (bagging) tahminleri birleştirir.  
   - Overfitting riskini azaltır ve değişken önem derecelerini raporlar.  

8. **Lojistik Regresyon**  
   - İkili sınıflandırma için kullanılan bir istatistiksel model.  
   - Olasılık öngörüsü üreterek sınıfa aitlik kararı verir.  

9. **k-Nearest Neighbors (k-NN)**  
   - Yeni örneği, eğitim setindeki *k* en yakın komşusunun sınıflarına göre sınıflandırır.  
   - Basit ama hesaplama maliyeti ve bellek gereksinimi yüksek olabilir.

## Sonuçlar
| Model               | Accuracy (%) | F₁-Score (%) |
| ------------------- | ------------ | ------------ |
| ZeroR               | 54.95        | 70.92        |
| OneR                | 58.24        | 66.07        |
| Naive Bayes         | 83.52        | 84.21        |
| J48 Karar Ağacı     | 69.23        | 70.83        |
| Random Forest       | 82.42        | 84.00        |
| Lojistik Regresyon  | 81.32        | 83.17        |
| k-NN                | 86.81        | 88.00        |
| Çoklu Algılayıcılar | 46.15        | 3.92         |
| DVM (SVM)           | 70.33        | 76.92        |
  
