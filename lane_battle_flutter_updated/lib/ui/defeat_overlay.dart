import 'package:flutter/material.dart';
import '../game/battle_game.dart';

class DefeatOverlay extends StatelessWidget {
  const DefeatOverlay({super.key, required this.game});
  final BattleGame game;


  static const String? _pixelFont = null;

  TextStyle _titleStyle(BuildContext context) => const TextStyle(
        fontFamily: _pixelFont,
        fontSize: 34,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: Colors.white,
        shadows: [
          Shadow(blurRadius: 0, offset: Offset(2, 2), color: Colors.black54),
        ],
      );

  TextStyle _subtitleStyle(BuildContext context) => TextStyle(
        fontFamily: _pixelFont,
        fontSize: 14,
        height: 1.2,
        letterSpacing: 0.6,
        color: Colors.white.withOpacity(0.75),
        shadows: const [
          Shadow(blurRadius: 0, offset: Offset(1, 1), color: Colors.black45),
        ],
      );

  TextStyle _buttonTextStyle() => TextStyle(
        fontFamily: _pixelFont,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
        color: Colors.white.withOpacity(0.9),
        shadows: const [
          Shadow(blurRadius: 0, offset: Offset(2, 2), color: Colors.black54),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.55), // gelap overlay background
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
            decoration: BoxDecoration(
              color: const Color(0xFF4A4A4A), // panel abu gelap
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 0,
                  spreadRadius: 0,
                  color: Colors.black54,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Defeat', style: _titleStyle(context), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text('your base was destroyed', style: _subtitleStyle(context), textAlign: TextAlign.center),
                const SizedBox(height: 18),

                _PixelButton(
                  label: 'Retry',
                  onTap: game.retryBattle,
                  textStyle: _buttonTextStyle(),
                ),
                const SizedBox(height: 14),
                _PixelButton(
                  label: 'Home',
                  onTap: game.goHome,
                  textStyle: _buttonTextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PixelButton extends StatelessWidget {
  const _PixelButton({
    required this.label,
    required this.onTap,
    required this.textStyle,
  });

  final String label;
  final VoidCallback onTap;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD8D8D8), // tombol abu terang
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.black87, width: 4), // border tebal pixel look
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 8),
                blurRadius: 0,
                spreadRadius: 0,
                color: Colors.black87, // shadow keras seperti pixel UI
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  width: 26,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: Text(
                  label,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
