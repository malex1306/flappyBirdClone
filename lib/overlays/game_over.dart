import 'package:flutter/material.dart';
import '../game/flappy_game.dart';

class GameOverMenu extends StatelessWidget {
  final FlappyGame game;

  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Game Over', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              game.reset();
              game.overlays.remove('GameOver');
              game.overlays.add('MainMenu');
              game.startGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
