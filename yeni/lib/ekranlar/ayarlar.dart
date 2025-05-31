import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/font_size_provider.dart';

class AyarlarSayfasi extends StatelessWidget {
  const AyarlarSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yazı Boyutu',
                      style: TextStyle(
                        fontSize: fontSizeProvider.fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.text_fields, color: Colors.blueGrey[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: fontSizeProvider.fontSize,
                            min: 12.0,
                            max: 24.0,
                            divisions: 12,
                            label: fontSizeProvider.fontSize.round().toString(),
                            onChanged: (value) {
                              fontSizeProvider.setFontSize(value);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${fontSizeProvider.fontSize.round()}',
                            style: TextStyle(
                              fontSize: fontSizeProvider.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Küçük',
                          style: TextStyle(
                            fontSize: fontSizeProvider.fontSize - 2,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                        Text(
                          'Büyük',
                          style: TextStyle(
                            fontSize: fontSizeProvider.fontSize + 2,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
