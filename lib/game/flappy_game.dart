import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/timer.dart';
import '../components/bird.dart';
import '../components/pipe.dart';

enum GameState { menu, playing, gameOver }

class FlappyGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Bird bird;
  late Timer pipeTimer;
  final Random random = Random();
  GameState state = GameState.menu;

  @override
  Future<void> onLoad() async {
    // Hintergrund laden
    final background = SpriteComponent()
      ..sprite = await loadSprite('bg.png')
      ..size = size
      ..anchor = Anchor.topLeft
      ..position = Vector2.zero();
    add(background);

    // Vogel hinzufügen
    bird = Bird();
    add(bird);

    // Timer für Pipes
    pipeTimer = Timer(2, onTick: spawnPipes, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state == GameState.playing) {
      pipeTimer.update(dt);
    }
  }

  @override
  void onTap() {
    if (state == GameState.playing) {
      bird.flap();
    }
  }

  void startGame() {
    state = GameState.playing;
    bird.reset();

    // Vorherige Pipes entfernen
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());

    overlays.remove('MainMenu');
    overlays.remove('GameOver');

    pipeTimer.start();
    resumeEngine();
  }

  void gameOver() {
    state = GameState.gameOver;
    overlays.add('GameOver');
    pipeTimer.stop();
    pauseEngine();
  }

  void reset() {
    bird.reset();
  }

  void spawnPipes() {
    final gapHeight = 150.0; // Lücke zwischen oberen und unteren Pipe
    final pipeWidth = 60.0;
    final pipeMinHeight = 50.0;

    final maxGapStart = size.y - gapHeight - pipeMinHeight;
    final gapY = pipeMinHeight + random.nextDouble() * maxGapStart;

    // Obere Pipe bis zur Lücke
    final topPipe = Pipe(
      position: Vector2(size.x, 0),
      isTop: true,
    )..size = Vector2(pipeWidth, gapY);

    // Untere Pipe von der Lücke bis zum unteren Rand
    final bottomPipe = Pipe(
      position: Vector2(size.x, gapY + gapHeight),
      isTop: false,
    )..size = Vector2(pipeWidth, size.y - (gapY + gapHeight));

    add(topPipe);
    add(bottomPipe);
  }
}
