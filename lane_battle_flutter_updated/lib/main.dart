import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/battle_game.dart';
import 'ui/credits_overlay.dart';   
import 'ui/defeat_overlay.dart';
import 'ui/hud_overlay.dart';
import 'ui/pause_overlay.dart';
import 'ui/start_overlay.dart';
import 'ui/victory_overlay.dart';
import 'ui/setting_overlay.dart';
import 'ui/quiz_overlay.dart';
import 'ui/hscore_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BattleGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: GameWidget<BattleGame>(
            game: game,
            overlayBuilderMap: {
              'Start': (context, game) => StartOverlay(game: game),
              'Hud': (context, game) => HudOverlay(game: game),
              'Pause': (context, game) => PauseOverlay(game: game),
              'Victory': (context, game) => VictoryOverlay(game: game),
              'Defeat': (context, game) => DefeatOverlay(game: game),
              'Credits': (context, game) => CreditsOverlay(game: game),
              'Sinopsis': (ctx, game) => SinopsisOverlay(game: game),
              'Settings': (context, game) => SettingOverlay(game: game),
              'QuizStage': (context, game) => QuizOverlay(game: game),
              'FinalScore': (ctx, game) => FinalScoreOverlay(game: game),
              'HighScore': (ctx, game) => HighScoreOverlay(game: game),
            },
            initialActiveOverlays: const ['Start'],
          ),
        ),
      ),
    );
  }
}
