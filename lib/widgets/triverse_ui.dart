import 'package:flutter/material.dart';

class TriverseScaffold extends StatelessWidget {
  final String title;
  final String levelName;
  final Color themeColor;
  final Widget child;
  final VoidCallback? onBack;

  const TriverseScaffold({
    super.key,
    required this.title,
    required this.levelName,
    required this.themeColor,
    required this.child,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      resizeToAvoidBottomInset: true, 
      body: Stack(
        children: [
          // 1. KATMAN: Arkaplan
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    themeColor.withValues(alpha: 0.15),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          
          // 2. KATMAN: Izgara Deseni
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                "https://www.transparenttextures.com/patterns/graphy.png", 
                repeat: ImageRepeat.repeat,
                errorBuilder: (c, o, s) => Container(),
              ),
            ),
          ),

          // 3. KATMAN: Ana İçerik
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: child, 
                  ),
                ),
                _buildBottomStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: themeColor.withValues(alpha: 0.3))),
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          // 1. Geri Butonu
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: themeColor),
            onPressed: onBack ?? () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 10),
          
          // 2. Başlık Alanı (ESNEK - Taşmayı önler)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("TRIVERSE OS v4.2", 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 10, letterSpacing: 1.5, fontFamily: 'Courier')),
                Text(title.toUpperCase(), 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // 3. Level Rozeti (Esnek)
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeColor.withValues(alpha: 0.5))
              ),
              child: Text(levelName, 
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomStatus() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_tethering, color: themeColor, size: 14),
          const SizedBox(width: 8),
          Flexible(
            child: Text("CONNECTION: STABLE  |  TEMP: -40°C",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: themeColor.withValues(alpha: 0.7), fontSize: 10, fontFamily: 'Courier')),
          ),
        ],
      ),
    );
  }
}

// --- OYUN KARTI (Mission Card) ---
class MissionCard extends StatelessWidget {
  final String header;
  final String story;
  final Widget content; 
  final Widget? footerInfo; 
  final Color color;

  const MissionCard({
    super.key,
    required this.header,
    required this.story,
    required this.content,
    required this.color,
    this.footerInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF111111).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 20, spreadRadius: 0),
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView( 
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kart Başlığı
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.3))),
                ),
                child: Row(
                  children: [
                    Icon(Icons.article_outlined, color: color, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(header, 
                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontFamily: 'Courier', letterSpacing: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Hikaye Metni
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  story,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'Courier', 
                  ),
                ),
              ),
              
              const Divider(color: Colors.white10, thickness: 1, indent: 20, endIndent: 20),

              // Oyun İçeriği
              Padding(
                padding: const EdgeInsets.all(20),
                child: content,
              ),

              // Footer Bilgisi
              if (footerInfo != null)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    border: Border(top: BorderSide(color: Colors.white10)),
                  ),
                  child: footerInfo,
                )
            ],
          ),
        ),
      ),
    );
  }
}