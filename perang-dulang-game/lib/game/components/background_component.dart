import 'dart:ui';

import 'package:flame/components.dart';

import '../battle_game.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameReference<BattleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    priority = -1000; 
    anchor = Anchor.topLeft;
    position = Vector2.zero();
    size = game.size; 

    try {
      sprite = await game.loadSprite('backgrounda.jpg');
    } catch (_) {
      sprite = null;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    position = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    if (sprite == null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = const Color(0xFF1E1E1E),
      );
      return;
    }
    super.render(canvas);
  }
}
