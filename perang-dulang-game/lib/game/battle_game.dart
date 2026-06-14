
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flame_audio/flame_audio.dart';

import 'components/background_component.dart';
import 'components/base_component.dart';
import 'components/reward_fx.dart';
import 'components/unit_component.dart';
import 'components/unit_enemy_component.dart';
import 'model/unit_config.dart';
import 'model/unit_type.dart';

class BattleGame extends FlameGame {
  // HUD 
  final coinsTotal = ValueNotifier<int>(0);
  final gems = ValueNotifier<int>(0);
  final coinsCollectedThisBattle = ValueNotifier<int>(0);
  int highScore = 0;


  final wave = ValueNotifier<int>(1);
  final pResource = ValueNotifier<int>(2);

  late BaseComponent playerBase;
  late BaseComponent enemyBase;

  final stage = ValueNotifier<int>(1);
  int quizScoreTotal = 0;

  final Set<UnitComponent> playerUnits = {};
  final Set<UnitComponent> enemyUnits = {};

  bool isBattleEnded = false;
  bool quizPassed = false;


  // Resource regen 
  double _pAcc = 0;
  final int _pMax = 100;
  final double _pRegenInterval = 1; // 1 detik per +1P


  final Map<int, List<List<_WaveSpawn>>> stageWaves = { 
    1: [ [_WaveSpawn(UnitType.babiHutan, 4, 1.2)], 
    [ _WaveSpawn(UnitType.babiHutan, 3, 1.0), 
    _WaveSpawn(UnitType.biawakapi, 2, 1.8), ],
     ],
     
      2: [ [ _WaveSpawn(UnitType.babiHutan, 6, 1.0), 
      _WaveSpawn(UnitType.buaye, 4, 1.5), ], 
      [ _WaveSpawn(UnitType.biawakapi, 5, 1.3), 
      _WaveSpawn(UnitType.buaye, 6, 1.2), 
      ], 
      ], 
      
      3: [ [ _WaveSpawn(UnitType.babiHutan, 8, 1.0), 
      _WaveSpawn(UnitType.biawakapi, 6, 1.2), 
      _WaveSpawn(UnitType.buaye, 10, 1.0), 
      ], 
      ], 
      };

  // Enemy wave plan
  final List<List<_WaveSpawn>> _waves = [
    [_WaveSpawn(UnitType.babiHutan, 4, 1.2),
      _WaveSpawn(UnitType.babiHutan, 2, 1.8),
      _WaveSpawn(UnitType.biawakapi, 4, 1.5),
    ],
    [
      _WaveSpawn(UnitType.babiHutan, 3, 1.0),
      _WaveSpawn(UnitType.biawakapi, 4, 1.8),
      _WaveSpawn(UnitType.buaye, 6, 1.0),
    ],
    [
      _WaveSpawn(UnitType.biawakapi, 5, 1.3),
      _WaveSpawn(UnitType.babiHutan, 8, 1.5),
      _WaveSpawn(UnitType.buaye, 10, 1.2),
    ],
  ];

  int _waveIndex = 0;
  int _planIndex = 0;
  int _spawnedInPlan = 0;
  double _enemySpawnTimer = 0;

  // Battlefield
  double laneY = 0;

  bool _basesCreated = false;

  // Volume  
  final bgmVolume = ValueNotifier<double>(1.0); 
  void setBgmVolume(double v) {
     bgmVolume.value = v.clamp(0.0, 1.0); 
     FlameAudio.bgm.audioPlayer.setVolume(bgmVolume.value); 
     }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background pertama
    await add(BackgroundComponent());

    // Bases
    playerBase = BaseComponent(isPlayer: true, maxHp: 220);
    enemyBase = BaseComponent(isPlayer: false, maxHp: 500);

    add(playerBase);
    add(enemyBase);

    _basesCreated = true;
    _layoutBattlefield(size);

  
    FlameAudio.bgm.initialize();

    //langsung play musik dari awal
    FlameAudio.bgm.play('start.mp3', volume: 1.0);
    pauseEngine();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layoutBattlefield(size);
  }

  void _layoutBattlefield(Vector2 size) {
    if (!_basesCreated) return;

    laneY = size.y * 0.56;

    playerBase.position = Vector2(40, laneY);
    enemyBase.position = Vector2(size.x - 40, laneY);
  }

  // ---------- Navigasi / UI  ----------
  void startBattle() {
    overlays.remove('Start');
    overlays.remove('Victory');
    overlays.remove('Defeat');
    overlays.remove('Pause');
    overlays.add('Hud');

    resetBattleState();
    resumeEngine();

    FlameAudio.bgm.stop(); 
    FlameAudio.bgm.play('musik.mp3', volume: bgmVolume.value);
  }

  void goHome() {
    overlays.remove('Hud');
    overlays.remove('Victory');
    overlays.remove('Defeat');
    overlays.remove('Pause');
    overlays.add('Start');

    resetBattleState();
    pauseEngine();

    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('start.mp3', volume: bgmVolume.value);
  }

  void pauseBattle() {
    if (isBattleEnded) return;
    if (overlays.isActive('Pause')) return;
    overlays.add('Pause');
    pauseEngine();
  }

  void closeCredits() {
    overlays.remove('Credits');
    if (overlays.isActive('Hud')) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void resumeBattle() {
    overlays.remove('Pause');
    if (!isBattleEnded) {
      resumeEngine();
    }
  }

  void retryBattle() {
    overlays.remove('Pause');
    overlays.remove('Victory');
    overlays.remove('Defeat');
    overlays.add('Hud');

    resetBattleState();
    resumeEngine();

   FlameAudio.bgm.stop(); 
    FlameAudio.bgm.play('musik.mp3', volume: bgmVolume.value);
  }

  // ---------- Gameplay ----------
  @override
  void update(double dt) {
    super.update(dt);
    if (isBattleEnded) return;

    _regenP(dt);
    _spawnEnemies(dt);
  }

  void _regenP(double dt) {
    _pAcc += dt;
    while (_pAcc >= _pRegenInterval) {
      _pAcc -= _pRegenInterval;
      if (pResource.value < _pMax) {
        pResource.value += 1;
      }
    }
  }

  void spawnPlayer(UnitType type) {
    if (isBattleEnded) return;

    final cfg = unitConfigs[type]!;
    if (pResource.value < cfg.costP) return;

    pResource.value -= cfg.costP;

    final u = UnitComponent(
      type: type,
      isPlayer: true,
      spawnPos: playerBase.position + Vector2(45, 0),
    );

    add(u);
    playerUnits.add(u);
  }

  void spawnEnemy(UnitType type) {
    if (isBattleEnded) return;

    final u = EnemyUnitComponent(
      type: type,
      spawnPos: enemyBase.position + Vector2(-45, 0),
    );

    add(u);
    enemyUnits.add(u);
  }

  void onUnitDied(UnitComponent unit) {
    if (unit.isPlayer) {
      playerUnits.remove(unit);
      return;
    }

    enemyUnits.remove(unit);

    // Coin reward
    final coin = unitConfigs[unit.type]!.coinReward;
    coinsCollectedThisBattle.value += coin;

    add(RewardFx(
      type: RewardType.coin,
      amount: coin,
      spawnPos: unit.position.clone(),
    ));

    // Resource "P" drop (+1)
    const pGain = 1;
    final nextP = (pResource.value + pGain).clamp(0, _pMax).toInt();
    pResource.value = nextP;

    add(RewardFx(
      type: RewardType.p,
      amount: pGain,
      spawnPos: unit.position.clone() + Vector2(0, -18),
    ));
  }

  void _spawnEnemies(double dt) {
    if (_waveIndex >= _waves.length) return;

    final currentPlans = _waves[_waveIndex];
    if (_planIndex >= currentPlans.length) {
      if (enemyUnits.isEmpty) {
        _advanceWaveOrWin();
      }
      return;
    }

    final plan = currentPlans[_planIndex];

    _enemySpawnTimer += dt;
    if (_enemySpawnTimer >= plan.interval) {
      _enemySpawnTimer = 0;

      spawnEnemy(plan.type);
      _spawnedInPlan++;

      if (_spawnedInPlan >= plan.count) {
        _planIndex++;
        _spawnedInPlan = 0;
      }
    }
  }

  void _advanceWaveOrWin() {
    _waveIndex++;
    if (_waveIndex >= _waves.length) {
      _victory();
      return;
    }

    _planIndex = 0;
    _spawnedInPlan = 0;
    _enemySpawnTimer = 0;
    wave.value = _waveIndex + 1;
  }

  void checkBattleEnd() {
    if (isBattleEnded) return;

    if (enemyBase.isDead) {
      _victory();
    } else if (playerBase.isDead) {
      _defeat();
    }
  }

 void _victory() {
  isBattleEnded = true;
  overlays.remove('Pause');

  // Kalau belum mencapai stage 3, tampilkan quiz
  if (stage.value <= 3) {
    overlays.add('QuizStage');
  } else {
    // Kalau sudah selesai stage 3, tampilkan skor akhir
    overlays.add('FinalScore');
  }

  pauseEngine();
  coinsTotal.value += coinsCollectedThisBattle.value;
}

  void _defeat() {
    isBattleEnded = true;
    overlays.remove('Pause');
    overlays.add('Defeat');
    pauseEngine();
  }

  void resetBattleState() {
    // Remove units
    for (final u in playerUnits.toList()) {
      u.removeFromParent();
    }
    for (final u in enemyUnits.toList()) {
      u.removeFromParent();
    }
    playerUnits.clear();
    enemyUnits.clear();

    // Reset bases
    playerBase.hp = playerBase.maxHp;
    enemyBase.hp = enemyBase.maxHp;

    // Reset state
    isBattleEnded = false;
    coinsCollectedThisBattle.value = 0;
    pResource.value = 2;

    _pAcc = 0;

    final wavesForStage = stageWaves[stage.value]!; 
    _waves ..clear() ..addAll(wavesForStage);

    _waveIndex = 0;
    _planIndex = 0;
    _spawnedInPlan = 0;
    _enemySpawnTimer = 0;
    wave.value = 1;

   
    _layoutBattlefield(size);
  }
}

class _WaveSpawn {
  final UnitType type;
  final int count;
  final double interval;

  _WaveSpawn(this.type, this.count, this.interval);
}
