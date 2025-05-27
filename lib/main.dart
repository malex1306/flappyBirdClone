import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/flappy_game.dart';
import 'overlays/main_menu.dart';
import 'overlays/game_over.dart';

void main(){
  runApp(
    GameWidget<FlappyGame>(
      game: FlappyGame(),
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOverMenu(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}