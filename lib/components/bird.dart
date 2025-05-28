import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../game/flappy_game.dart';
import 'pipe.dart';

class Bird extends SpriteComponent with HasGameRef<FlappyGame>, CollisionCallbacks {
  double velocity = 0;
  final double gravity = 500;
  final double jumpPower = -250;

  late Sprite upFlap;
  late Sprite midFlap;
  late Sprite downFlap;

  Bird() : super(size: Vector2.all(50));

  @override
  Future<void> onLoad() async {
    // Lade alle Sprites für die Animation
    upFlap = await gameRef.loadSprite('yellowbird-upflap.png');
    midFlap = await gameRef.loadSprite('yellowbird-midflap.png');
    downFlap = await gameRef.loadSprite('yellowbird-downflap.png');

    sprite = midFlap;
    position = Vector2(100, gameRef.size.y / 2);
    anchor = Anchor.center;

    // Hitbox etwas kleiner und zentriert
    final hitboxSize = size * 0.8;
    final hitboxPosition = (size - hitboxSize) / 2;

    add(RectangleHitbox.relative(
      Vector2.all(0.8),
      parentSize: size,
      position: hitboxPosition,
    )..debugMode = true); // Entferne debugMode für Produktion
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity += gravity * dt;
    position.y += velocity * dt;

    // Sprite basierend auf Flugrichtung wechseln
    if (velocity < -100) {
      sprite = upFlap;
    } else if (velocity > 100) {
      sprite = downFlap;
    } else {
      sprite = midFlap;
    }

    // Game Over bei Decke oder Boden
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

    if (other is Pipe) {
      gameRef.gameOver();
    }
  }
}
