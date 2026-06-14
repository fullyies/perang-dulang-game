import 'package:flutter/material.dart';
import '../game/battle_game.dart';


class StartOverlay extends StatelessWidget {
  const StartOverlay({super.key, required this.game});
  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF101010),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgstart.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF101010),
              ),
            ),
          ),
          
          Positioned.fill(
            child: Opacity(
              opacity: 0.20,
              child: Container(color: Colors.green),
            ),
          ),
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Perang Dulang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Munculkan Mob, hancurkan base musuh.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),

                  // PLAY button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => game.startBattle(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A5F4A), Color(0xFF2D4A2D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              CustomPaint(
                                painter: CandiButtonPainter(),
                                child: Container(),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                child: const Text(
                                  'PLAY',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'Tip: Resource P regenerasi setiap 1 detik.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),

                   // CREDITS button
        SizedBox(
          width: 220, // lebar tetap biar sama panjang
          child: ElevatedButton.icon(
            onPressed: () {
              game.pauseEngine();
              game.overlays.add('Credits');
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('CREDITS'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15), // ngikut lebar SizedBox
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), 
              ),
            ),
          ),
        ),

        const SizedBox(height: 12), // jarak dikit biar nggak nempel

        // SETTINGS button
        SizedBox(
          width: 220, // Lebarnya disamain sama tombol CREDITS
          child: ElevatedButton.icon(
            onPressed: () {
              game.pauseEngine();
              game.overlays.add('Settings');
            },
            icon: const Icon(Icons.settings),
            label: const Text('SETTINGS'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Biar seragam
                       ),
                     ),
                    ),
                  ),

                  const SizedBox(height: 12),
   SizedBox(
  width: 220,
  child: ElevatedButton.icon(
    onPressed: () {
      game.pauseEngine();
      game.overlays.add('HighScore');
    },
    icon: const Icon(Icons.star),
    label: const Text('HIGH SCORE'),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter untuk efek pixel pada tombol PLAY
class CandiButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const pixelSize = 6.0;

    // "Stone" pattern
    for (double x = 0; x < size.width; x += pixelSize) {
      for (double y = 0; y < size.height; y += pixelSize) {
        final noise = ((x + y) / pixelSize) % 5;

        if (noise < 1) {
          paint.color = Colors.white.withOpacity(0.1);
        } else if (noise < 2) {
          paint.color = const Color(0xFF5A6A6A).withOpacity(0.2);
        } else {
          continue;
        }

        canvas.drawRect(
          Rect.fromLTWH(x, y, pixelSize - 1, pixelSize - 1),
          paint,
        );
      }
    }

    // "Moss" accent
    paint.color = const Color(0xFF4A8A5A).withOpacity(0.15);
    for (double y = 0; y < size.height; y += pixelSize * 2) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.3, y, size.width * 0.4, pixelSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
