import 'package:flame/components.dart';

import '../model/unit_type.dart';
import 'unit_component.dart';


class EnemyUnitComponent extends UnitComponent {
  EnemyUnitComponent({
    required super.type,
    required super.spawnPos,
  }) : super(isPlayer: false);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load sprite berdasarkan tipe enemy
    final spritePath = _spritePathForEnemy(type);

    try {
      final sprite = await game.loadSprite(spritePath);
      spriteComponent = SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
        position: size / 2,
      );

    

      await add(spriteComponent!);
    } catch (_) {
      spriteComponent = null;
    }
  }

  String _spritePathForEnemy(UnitType t) {
    switch (t) {
      case UnitType.babiHutan:
        return 'babiHutan.png';
      case UnitType.biawakapi:
        return 'biawakapi.png';
      case UnitType.buaye:
        return 'buaye.png';
      default:
        return 'babiHutan.png';
    }
  }
}
