import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../game/flappy_game.dart';
import 'pipe.dart'; // Importiere Pipe für Typprüfung

class Bird extends SpriteComponent with HasGameRef<FlappyGame>, CollisionCallbacks {
  double velocity = 0;
  final double gravity = 600;
  final double jumpPower = -250;

  Bird() : super(size: Vector2.all(50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('flappy.png');
    position = Vector2(100, gameRef.size.y / 2);
    anchor = Anchor.center;
    add(RectangleHitbox());
    // debugMode = true; // Zum Testen der Hitbox sichtbar machen
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity += gravity * dt;
    position.y += velocity * dt;

    if (position.y > gameRef.size.y || position.y < 0) {
      gameRef.gameOver();
    }
  }

  void flap() {
    velocity = jumpPower;
  }

  void reset() {
    position = Vector2(100, gameRef.size.y / 2);
    velocity = 0;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Kollision mit einer Pipe führt zum Game Over
    if (other is Pipe) {
      gameRef.gameOver();
    }
  }
}
