import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CoinFx extends PositionComponent {
  CoinFx(Vector2 pos)
      : _start = pos.clone(),
        super(position: pos.clone());

  final Vector2 _start;
  double _t = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    size = Vector2(10, 10);
    priority = 1000;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    position = _start + Vector2(0, -30 * _t);
    if (_t >= 0.6) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final alpha = (1.0 - (_t / 0.6)).clamp(0.0, 1.0);
    final p = Paint()..color = Colors.amber.withOpacity(alpha);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 5, p);
  }
}
