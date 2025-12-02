import 'package:flutter/material.dart';
import '../utils/app_texts.dart';

class PurchaseScreen extends StatefulWidget {
  final String language;
  const PurchaseScreen({super.key, required this.language});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  int _currentImageIndex = 0;
  final List<String> images = [
    'assets/images/triverse_box.jpg',
    'assets/images/triverse_gameplay.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b0e17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TRIVERSE',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.cyanAccent,
              letterSpacing: 4,
              fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FOTOĞRAF ALANI (NEON ÇERÇEVE)
            Container(
              height: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.cyanAccent, width: 4),
                boxShadow: [
                  BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.6),
                      blurRadius: 40,
                      spreadRadius: 8),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    Image.asset(images[_currentImageIndex], fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),

            // DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => GestureDetector(
                  onTap: () => setState(() => _currentImageIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentImageIndex == index ? 40 : 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _currentImageIndex == index
                          ? Colors.cyanAccent
                          : Colors.grey,
                      boxShadow: _currentImageIndex == index
                          ? [
                              const BoxShadow(
                                  color: Colors.cyanAccent, blurRadius: 15)
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // BAŞLIK
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.purpleAccent])
                  .createShader(bounds),
              child: const Text(
                'TRIVERSE\nSecret of the Portals',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Text('TechLuna Games',
                style: TextStyle(color: Colors.cyan, fontSize: 20)),

            const SizedBox(height: 40),

            // FİYAT VE İNDİRİM
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('₺799',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough)),
                SizedBox(width: 20),
                Text('₺499',
                    style: TextStyle(
                        fontSize: 68,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF00ff88))),
              ],
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(AppTexts.get('sale_text', widget.language),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 18)),
            ),

            const SizedBox(height: 20),
            Text(AppTexts.get('stock_text', widget.language),
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 50),

            // SATIN AL BUTONU (GRADIENT)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(AppTexts.get('redirect_msg', widget.language)),
                    backgroundColor: Colors.green));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blueAccent]),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.7),
                        blurRadius: 40,
                        spreadRadius: 10)
                  ],
                ),
                child: Text(
                  AppTexts.get('buy_now', widget.language),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 3),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // GÜVEN İKONLARI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TrustIcon(
                    text: AppTexts.get('secure_pay', widget.language),
                    icon: Icons.lock),
                TrustIcon(
                    text: AppTexts.get('shipping', widget.language),
                    icon: Icons.local_shipping),
                TrustIcon(
                    text: AppTexts.get('original', widget.language),
                    icon: Icons.verified),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class TrustIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  const TrustIcon({super.key, required this.text, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyanAccent, width: 3),
            boxShadow: [
              BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.4), blurRadius: 20)
            ],
          ),
          child: Icon(icon, color: Colors.cyanAccent, size: 36),
        ),
        const SizedBox(height: 10),
        Text(text,
            style: const TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
