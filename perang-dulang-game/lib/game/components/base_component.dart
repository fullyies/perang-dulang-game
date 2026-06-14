import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../battle_game.dart';

class BaseComponent extends SpriteComponent with HasGameReference<BattleGame> {
  BaseComponent({
    required this.isPlayer,
    required this.maxHp,
  });

  final bool isPlayer;
  final double maxHp;
  double hp = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Panggil super.onLoad()

    hp = maxHp;
    anchor = Anchor.center;

    size = Vector2(400, 300); // ukuran gambar
    const double scaleFactor = 0.6; // Scale factor 0.6 ini untuk ukuran base
    try {
      sprite = await game.loadSprite('tower.png');
      size = sprite!.originalSize * scaleFactor;
    } catch (_) {
      sprite = null;
    }
  }

  void takeDamage(double dmg) {
    hp -= dmg;
    if (hp < 0) hp = 0;
  }

  bool get isDead => hp <= 0;

  @override
  void render(Canvas canvas) {
    super.render(canvas); // Panggil super.render untuk menggambar sprite

    // 1. Lebar HP bar
    final double desiredHpBarWidth = size.x * 0.2;

    // 2. Tinggi HP bar
    const double barH = 8.0;

    // 3. Posisi Y HP bar (untuk membuat "terpisah" dan "dekat")
    const double gapFromBaseTop = -150; // <--- Jarak dari bagian paling atas base ke HP bar
    final double hpBarOffsetY = -size.y / 2 - barH - gapFromBaseTop;

    // 4. Posisi X HP bar (untuk membuat di tengah, karena lebarnya sudah pendek)
    final double hpBarOffsetX = (size.x - desiredHpBarWidth) / 2;

    final double pct = (hp / maxHp).clamp(0.0, 1.0);

    // Rectangle untuk latar belakang HP bar (hitam transparan)
    final bg = Rect.fromLTWH(hpBarOffsetX, hpBarOffsetY, desiredHpBarWidth, barH);
    // Rectangle untuk porsi HP yang tersisa (merah)
    final fg = Rect.fromLTWH(hpBarOffsetX, hpBarOffsetY, desiredHpBarWidth * pct, barH);

    canvas.drawRect(bg, Paint()..color = Colors.black.withOpacity(0.25));
    canvas.drawRect(fg, Paint()..color = const Color(0xFFE74C3C));
  }
}
