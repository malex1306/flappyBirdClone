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
          Image.asset(
            'assets/images/gameover.png',
            width: 200,
          ),
          const SizedBox(height: 400),
          ElevatedButton(
            onPressed: () {
              game.reset();
              game.overlays.remove('GameOver');
              game.overlays.add('MainMenu');
              game.startGame();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
