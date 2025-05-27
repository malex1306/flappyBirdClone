import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:flappy_game/game/flappy_game.dart';

void main() {
  testWidgets('FlappyGame smoke test', (WidgetTester tester) async {
    final game = FlappyGame();

    await tester.pumpWidget(
      GameWidget<FlappyGame>(
        game: game,
      ),
    );

    expect(find.byType(GameWidget<FlappyGame>), findsOneWidget);
  });
}
