import 'package:flutter/material.dart';
import '../game/battle_game.dart';

class SettingOverlay extends StatelessWidget {
  const SettingOverlay({super.key, required this.game});
  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Slider volume
              ValueListenableBuilder<double>(
                valueListenable: game.bgmVolume,
                builder: (context, value, _) {
                  return Column(
                    children: [
                      Text(
                        'Volume: ${(value * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: value,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${(value * 100).toInt()}%',
                        onChanged: (newValue) {
                          game.setBgmVolume(newValue);
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('Settings');
                  // balik ke Start overlay
                  game.overlays.add('Start');
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
