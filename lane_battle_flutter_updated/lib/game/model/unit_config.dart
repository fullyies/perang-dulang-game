import 'unit_type.dart';

class UnitConfig {
  final double maxHp;
  final double damage;
  final double speed;
  final double attackRange;
  final double attackCooldown;
  final int costP;
  final int coinReward;

  UnitConfig({
    required this.maxHp,
    required this.damage,
    required this.speed,
    required this.attackRange,
    required this.attackCooldown,
    required this.costP,
    required this.coinReward,
  });
}

final Map<UnitType, UnitConfig> unitConfigs = {
  // ===== PLAYER UNITS =====
  UnitType.farmer: UnitConfig(
    maxHp: 50,
    damage: 8,
    speed: 40,
    attackRange: 30,
    attackCooldown: 1.2,
    costP: 1,
    coinReward: 0,
  ),
  UnitType.swordman: UnitConfig(
    maxHp: 120,
    damage: 20,
    speed: 35,
    attackRange: 35,
    attackCooldown: 1.0,
    costP: 5,
    coinReward: 0,
  ),
  UnitType.spearman: UnitConfig(
    maxHp: 80,
    damage: 15,
    speed: 45,
    attackRange: 50,
    attackCooldown: 1.5,
    costP: 4,
    coinReward: 0,
  ),
  
  // ===== ENEMY UNITS =====
  UnitType.babiHutan: UnitConfig(
    maxHp: 60,
    damage: 12,
    speed: 50,
    attackRange: 30,
    attackCooldown: 1.0,
    costP: 0,
    coinReward: 5,
  ),
  UnitType.biawakapi: UnitConfig(
    maxHp: 100,
    damage: 18,
    speed: 30,
    attackRange: 40,
    attackCooldown: 1.5,
    costP: 0,
    coinReward: 8,
  ),
  UnitType.buaye: UnitConfig(
    maxHp: 200,
    damage: 25,
    speed: 25,
    attackRange: 30,
    attackCooldown: 2.0,
    costP: 0,
    coinReward: 12,
  ),
};