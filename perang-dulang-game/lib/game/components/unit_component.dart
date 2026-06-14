import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../battle_game.dart';
import '../model/unit_config.dart';
import '../model/unit_type.dart';

class UnitComponent extends PositionComponent with HasGameReference<BattleGame> {
  UnitComponent({
    required this.type,
    required this.isPlayer,
    required Vector2 spawnPos,
  }) : super(position: spawnPos);

  final UnitType type;
  final bool isPlayer;

  late final UnitConfig cfg;

  double hp = 0;
  double _atkCd = 0;

  SpriteComponent? spriteComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    cfg = unitConfigs[type]!;
    hp = cfg.maxHp;

    anchor = Anchor.center;
    size = Vector2(38, 38);

 
    if (isPlayer) {
      final spritePath = _spritePathForPlayer(type);

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
  }

  String _spritePathForPlayer(UnitType t) {
    switch (t) {
      case UnitType.farmer:
        return 'farmer.png';
      case UnitType.swordman:
        return 'swordman.png';
      case UnitType.spearman:
        return 'spearman.png';
      default:
        return 'farmer.png';
    }
  }

  void takeDamage(double dmg) {
    hp -= dmg;
    if (hp <= 0) {
      hp = 0;
      game.onUnitDied(this);
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isBattleEnded) return;

    _atkCd -= dt;
    if (_atkCd < 0) _atkCd = 0;

    final targets = isPlayer ? game.enemyUnits : game.playerUnits;

    UnitComponent? targetUnit;
    double bestDist = double.infinity;

    for (final u in targets) {
      final dx = u.position.x - position.x;
      final dist = dx.abs();

      final isInFront = isPlayer ? (dx >= 0) : (dx <= 0);
      final canTarget = isInFront || dist <= cfg.attackRange;

      if (canTarget && dist < bestDist) {
        bestDist = dist;
        targetUnit = u;
      }
    }

    // Attack unit jika berada di range
    if (targetUnit != null && bestDist <= cfg.attackRange) {
      _attackUnit(targetUnit);
      return;
    }

    
    final enemyBase = isPlayer ? game.enemyBase : game.playerBase;
    final baseDx = enemyBase.position.x - position.x;
    final baseDist = baseDx.abs();
    final isBaseInFront = isPlayer ? (baseDx >= 0) : (baseDx <= 0);

    if (isBaseInFront && baseDist <= (cfg.attackRange + 10)) {
      _attackBase(enemyBase);
      return;
    }

    // Maju
    final dir = isPlayer ? 1.0 : -1.0;
    position.x += dir * cfg.speed * dt;

    
    position.x = position.x.clamp(40.0, game.size.x - 40.0).toDouble();
  }

  void _attackUnit(UnitComponent target) {
    if (_atkCd > 0) return;
    _atkCd = cfg.attackCooldown;
    target.takeDamage(cfg.damage);
  }

  void _attackBase(dynamic base) {
    if (_atkCd > 0) return;
    _atkCd = cfg.attackCooldown;
    base.takeDamage(cfg.damage);
    game.checkBattleEnd();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

   
    if (spriteComponent == null) {
      final bodyPaint = Paint()
        ..color = isPlayer
            ? const Color(0xFFFAF3D7)
            : const Color(0xFFD7D7D7);
      final outline = Paint()
        ..color = Colors.black.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.x, size.y),
          const Radius.circular(10),
        ),
        bodyPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.x, size.y),
          const Radius.circular(10),
        ),
        outline,
      );
    }

    // HP bar
    final pct = (hp / cfg.maxHp).clamp(0.0, 1.0);
    final barBg = Rect.fromLTWH(0, -10, size.x, 6);
    final barFg = Rect.fromLTWH(0, -10, size.x * pct, 6);

    canvas.drawRect(barBg, Paint()..color = Colors.black.withOpacity(0.25));

    final hpColor =
        isPlayer ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C);
    canvas.drawRect(barFg, Paint()..color = hpColor);
  }
}
