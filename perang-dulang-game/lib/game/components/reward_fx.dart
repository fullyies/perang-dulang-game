import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum RewardType { coin, p }

class RewardFx extends PositionComponent {
  RewardFx({
    required this.type,
    required this.amount,
    required Vector2 spawnPos,
  })  : _start = spawnPos.clone(),
        super(position: spawnPos.clone());

  final RewardType type;
  final int amount;
  final Vector2 _start;

  double _t = 0;
  final double duration = 1.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    size = Vector2(72, 22);
    priority = 1000;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;

    final p = (_t / duration).clamp(0.0, 1.0);
    position = _start + Vector2(0, -38 * p);

    if (_t >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final alpha = (1.0 - (_t / duration)).clamp(0.0, 1.0);
    final color = type == RewardType.coin ? Colors.amber : Colors.lightBlueAccent;

    // icon
    final iconPaint = Paint()..color = color.withOpacity(alpha);
    const r = 8.0;
    final iconCenter = Offset(12, size.y / 2);
    canvas.drawCircle(iconCenter, r, iconPaint);

    // label
    final label = type == RewardType.coin ? '+$amount' : '+${amount}P';
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white.withOpacity(alpha),
          fontWeight: FontWeight.bold,
          fontSize: 14,
          shadows: const [Shadow(blurRadius: 6, color: Colors.black)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.x - 26);

    tp.paint(canvas, Offset(24, (size.y - tp.height) / 2));
  }
}
