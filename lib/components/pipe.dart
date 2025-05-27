import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../game/flappy_game.dart';

class Pipe extends PositionComponent with HasGameRef<FlappyGame>, CollisionCallbacks {
  static const double speed = 150;
  final bool isTop;

  late RectangleComponent rect;

  bool hasScored = false; // Damit wir nur einmal punkten

  Pipe({required Vector2 position, required this.isTop}) {
    this.position = position;
    size = Vector2(60, 300);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    // Farbiges Rechteck als Pipe (rot)
    rect = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.red,
    );
    add(rect);

    // Hitbox für Kollisionen
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    // Punkt hinzufügen, wenn der Vogel die Pipe passiert hat
    if (!hasScored && position.x + size.x < gameRef.bird.x) {
      hasScored = true;
      if (!isTop) { // Punkte nur bei der unteren Pipe zählen
        gameRef.increaseScore();
      }
    }

    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
