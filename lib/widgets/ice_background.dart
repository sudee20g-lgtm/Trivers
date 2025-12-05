import 'package:flutter/material.dart';

class IceBackground extends StatelessWidget {
  final Widget child;
  final Color color;

  const IceBackground({
    super.key,
    required this.child,
    this.color = Colors.cyanAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. OYUN İÇERİĞİ (Arkada Kalmasın diye en altta değil, stack mantığı)
        // Ama içerik kaydırılabilir olduğu için bunu arkaya, süsü öne koyacağız.
        Positioned.fill(
          child: child, // Oyunun asıl ekranı buraya gelecek
        ),

        // 2. BUZ SİLÜETİ (EN ALTTA SABİT)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 150, // Yükseklik
          child: IgnorePointer( // Tıklamaları engelle, arkadaki butonlara basılabilsin
            child: CustomPaint(
              painter: _IcePeakPainter(color: color),
            ),
          ),
        ),
        
        // 3. EN ALTTAKI HAFİF SİS (Atmosfer)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    color.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// BUZ DAĞLARINI ÇİZEN RESSAM
class _IcePeakPainter extends CustomPainter {
  final Color color;
  _IcePeakPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.1), // Üst kısımlar şeffaf
          color.withValues(alpha: 0.6), // Alt kısımlar koyu
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5); // Neon parlama

    final path = Path();
    
    // Sol alt köşeden başla
    path.moveTo(0, size.height);
    
    // Zikzak çizerek buzullar oluştur
    // (Matematiksel olarak ekran genişliğine göre tepecikler)
    path.lineTo(0, size.height * 0.7); 
    path.lineTo(size.width * 0.15, size.height * 0.4); // Zirve 1
    path.lineTo(size.width * 0.30, size.height * 0.8); // Çukur
    path.lineTo(size.width * 0.45, size.height * 0.3); // Zirve 2 (Büyük)
    path.lineTo(size.width * 0.60, size.height * 0.75);
    path.lineTo(size.width * 0.75, size.height * 0.5); // Zirve 3
    path.lineTo(size.width * 0.90, size.height * 0.85);
    path.lineTo(size.width, size.height * 0.6); // Sağ kenar bitiş
    
    path.lineTo(size.width, size.height); // Sağ alt köşe
    path.close(); // Kapat

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint); // Kenar çizgilerini çiz
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}