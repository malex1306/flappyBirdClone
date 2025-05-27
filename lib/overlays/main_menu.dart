import 'package:flutter/material.dart';
import '../game/flappy_game.dart';

class MainMenu extends StatelessWidget {
  final FlappyGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          game.startGame();
          game.overlays.remove('MainMenu');
        },
        child: const Text('Start Game'),
      ),
    );
  }
}
