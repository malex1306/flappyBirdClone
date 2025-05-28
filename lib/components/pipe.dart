import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../game/flappy_game.dart';

class Pipe extends PositionComponent with HasGameRef<FlappyGame>, CollisionCallbacks {
  static const double speed = 150;
  final bool isTop;

  late RectangleComponent rect;
  bool hasScored = false;

  Pipe({required Vector2 position, required this.isTop}) {
    this.position = position;
    size = Vector2(60, 300);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    // Pipe-Bild laden
    final sprite = await gameRef.loadSprite('pipe-green.png');

    // Pipe-Sprite anzeigen
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.topLeft,
    );

    // Wenn obere Pipe, dann flippe das Bild vertikal
    if (isTop) {
      spriteComponent.scale = Vector2(1, -1); // Vertikal spiegeln
      spriteComponent.position = Vector2(0, size.y); // Korrektur bei Flip
    }

    add(spriteComponent);

    // Hitbox hinzufügen (angepasst an die Größe)
    final hitboxSize = size * 0.97;
    final offset = (size - hitboxSize) / 2;

    add(RectangleHitbox.relative(
      Vector2.all(0.98),
      parentSize: size,
      position: offset,
    )..debugMode = false); // Debug anzeigen optional
  }


  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    if (!hasScored && position.x + size.x < gameRef.bird.x) {
      hasScored = true;
      if (!isTop) {
        gameRef.increaseScore();
      }
    }

    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
