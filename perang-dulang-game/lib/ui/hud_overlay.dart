import 'package:flutter/material.dart';
import '../game/battle_game.dart';
import '../game/model/unit_config.dart';
import '../game/model/unit_type.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.game});
  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // TOP BAR
        Positioned(
          top: 10,
          left: 12,
          right: 12,
          child: _TopBar(game: game),
        ),

        // BOTTOM SPAWN BAR
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomBar(game: game),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.game});
  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris pertama: coin, coin battle, gems, pause
        Row(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: game.coinsTotal,
              builder: (_, c, __) => _Pill(text: formatCoins(c)),
            ),
            const SizedBox(width: 10),
            ValueListenableBuilder<int>(
              valueListenable: game.coinsCollectedThisBattle,
              builder: (_, cBattle, __) => _Pill(text: '+$cBattle'),
            ),
            const SizedBox(width: 10),
            Expanded(child: Container()), // spacer
            ValueListenableBuilder<int>(
              valueListenable: game.gems,
              builder: (_, g, __) => _Pill(text: '$g'),
            ),
            const SizedBox(width: 8),
            _IconPill(
              icon: Icons.pause,
              onTap: () => game.pauseBattle(),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // Baris kedua: Stage + Quiz status + Gelombang
        Row(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: game.stage,
              builder: (_, s, __) => _Pill(text: 'Stage $s'),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: game.quizPassed
                    ? Colors.green.withOpacity(0.7)
                    : Colors.red.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Quiz belum lolos', 
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ValueListenableBuilder<int>(
              valueListenable: game.wave,
              builder: (_, w, __) => _Pill(text: 'Gelombang $w'),
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.game});
  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
      color: Colors.black.withOpacity(0.55),
      child: SafeArea(
        top: false,
        child: ValueListenableBuilder<int>(
          valueListenable: game.pResource,
          builder: (_, p, __) {
            return Row(
              children: [
                // RESOURCE P
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'P\n$p',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // SPAWN BUTTONS AREA
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _SpawnButton(
                          unitName: 'PETANI',
                          imagePath: 'assets/images/farmer.png',
                          cost: unitConfigs[UnitType.farmer]!.costP,
                          enabled: p >= unitConfigs[UnitType.farmer]!.costP,
                          onTap: () => game.spawnPlayer(UnitType.farmer),
                        ),
                        const SizedBox(width: 12),
                        _SpawnButton(
                          unitName: 'PENOMBAK',
                          imagePath: 'assets/images/spearman.png',
                          cost: unitConfigs[UnitType.spearman]!.costP,
                          enabled: p >= unitConfigs[UnitType.spearman]!.costP,
                          onTap: () => game.spawnPlayer(UnitType.spearman),
                        ),
                        const SizedBox(width: 12),
                        _SpawnButton(
                          unitName: 'PENDEKAR',
                          imagePath: 'assets/images/swordman.png',
                          cost: unitConfigs[UnitType.swordman]!.costP,
                          enabled: p >= unitConfigs[UnitType.swordman]!.costP,
                          onTap: () => game.spawnPlayer(UnitType.swordman),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SpawnButton extends StatelessWidget {
  const _SpawnButton({
    required this.unitName,
    required this.imagePath,
    required this.cost,
    required this.onTap,
    required this.enabled,
  });

  final String unitName;
  final String imagePath;
  final int cost;
  final VoidCallback onTap;
  final bool enabled;

  static const double height = 140;
  static const double width = 100;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled ? Colors.amber.withOpacity(0.6) : Colors.white24,
              width: 2,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // NAMA UNIT DI ATAS
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  unitName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: enabled ? Colors.white : Colors.white54,
                    letterSpacing: 0.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // GAMBAR KARAKTER PIXEL ART
              Expanded(
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none, // untuk pixel art
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),
                ),
              ),

              // COST DI BAWAH
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: enabled
                      ? Colors.amber.withOpacity(0.9)
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black45,
                    width: 1,
                  ),
                ),
                child: Text(
                  'P$cost',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: enabled ? Colors.black87 : Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  const _IconPill({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// helper untuk format coin
String formatCoins(int c) {
  if (c >= 1000) {
    double inK = c / 1000;
    if (inK == inK.roundToDouble()) {
      return '${inK.toInt()}k';
    }
    return '${inK.toStringAsFixed(2)}k';
  }
  return c.toString();
}
