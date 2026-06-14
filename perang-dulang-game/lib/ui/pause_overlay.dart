import 'package:flutter/material.dart';
import '../game/battle_game.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key, required this.game});
  final BattleGame game;

  static const String? _pixelFont = null;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontFamily: _pixelFont,
      fontSize: 36,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.1,
      color: Colors.white,
      shadows: [
        Shadow(offset: Offset(2, 2), blurRadius: 0, color: Colors.black),
      ],
    );

    return Material(
      color: Colors.black.withOpacity(0.60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.fromLTRB(36, 28, 36, 26),
            decoration: BoxDecoration(
              color: const Color(0xFF565656), // panel abu gelap seperti gambar
              borderRadius: BorderRadius.circular(36),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 12),
                  blurRadius: 0,
                  color: Colors.black87, // shadow keras
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Paused',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),

                _PixelOvalButton(
                  label: 'Resume',
                  fontFamily: _pixelFont,
                  onTap: () => game.resumeBattle(),
                ),
                const SizedBox(height: 12),

                _PixelOvalButton(
                  label: 'Retry',
                  fontFamily: _pixelFont,
                  onTap: () => game.retryBattle(),
                ),
                const SizedBox(height: 12),

                _PixelOvalButton(
                  label: 'Home',
                  fontFamily: _pixelFont,
                  onTap: () => game.goHome(),
                ),

                Row( mainAxisAlignment: 
                MainAxisAlignment.spaceEvenly, children: [ 
                  ElevatedButton( onPressed: () { // turunkan volume 10% 
                  game.setBgmVolume(game.bgmVolume.value - 0.1); }, 
                  child: const Icon(Icons.volume_down, color: Colors.black), 
                  style: ElevatedButton.styleFrom( backgroundColor: Colors.white, 
                  shape: const CircleBorder(), 
                  padding: const EdgeInsets.all(16), 
                  ),
                   ), 
                   ElevatedButton( onPressed: () { // naikkan volume 10% 
                   game.setBgmVolume(game.bgmVolume.value + 0.1); }, 
                   child: const Icon(Icons.volume_up, color: Colors.black), 
                   style: ElevatedButton.styleFrom( backgroundColor: Colors.white, 
                   shape: const CircleBorder(), 
                   padding: const EdgeInsets.all(16), ), 
                   ), 
                   ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PixelOvalButton extends StatefulWidget {
  const _PixelOvalButton({
    required this.label,
    required this.onTap,
    required this.fontFamily,
  });

  final String label;
  final VoidCallback onTap;
  final String? fontFamily;

  @override
  State<_PixelOvalButton> createState() => _PixelOvalButtonState();
}

class _PixelOvalButtonState extends State<_PixelOvalButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // Efek tombol game: ditekan turun sedikit, shadow memendek
    final dy = _pressed ? 4.0 : 0.0;
    final shadowDy = _pressed ? 4.0 : 8.0;

    final textStyle = TextStyle(
      fontFamily: widget.fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.0,
      color: Colors.white,
      shadows: const [
        Shadow(offset: Offset(2, 2), blurRadius: 0, color: Colors.black),
      ],
    );

    return SizedBox(
      height: 64,
      width: double.infinity,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          transform: Matrix4.translationValues(0, dy, 0),
          decoration: BoxDecoration(
            color: const Color(0xFFDADADA), // abu terang tombol
            borderRadius: BorderRadius.circular(30), // oval rounded
            border: Border.all(color: Colors.black, width: 3), // border tebal
            boxShadow: [
              BoxShadow(
                offset: Offset(0, shadowDy),
                blurRadius: 0,
                color: Colors.black, // shadow keras tanpa blur
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  width: 28,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.40),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // highlight tipis atas tombol
              Positioned(
                left: 18,
                right: 18,
                top: 6,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Center(child: Text(widget.label, style: textStyle)),
            ],
          ),
        ),
      ),
    );
  }
}
