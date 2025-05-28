import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/timer.dart';
import '../components/bird.dart';
import '../components/pipe.dart';
import 'package:flutter/material.dart';

enum GameState { menu, playing, gameOver }

class FlappyGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Bird bird;
  late Timer pipeTimer;
  final Random random = Random();
  GameState state = GameState.menu;

  int score = 0;
  late TextComponent scoreText;

  @override
  Future<void> onLoad() async {
    // Hintergrund laden
    final background = SpriteComponent()
      ..sprite = await loadSprite('background-day.png')
      ..size = size
      ..anchor = Anchor.topLeft
      ..position = Vector2.zero();
    add(background);

    final baseHeight = 112.0;
    final base = SpriteComponent()
      ..sprite = await loadSprite('base.png')
      ..size = Vector2(size.x, baseHeight)
      ..position = Vector2(0, size.y - baseHeight)
      ..anchor = Anchor.topLeft;
    add(base);

    scoreText = TextComponent(
      text: '0',
      position: Vector2(20, 20),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 32,
        ),
      ),
    );
    add(scoreText);

    // Vogel hinzufügen
    bird = Bird();
    add(bird);

    // Timer für Pipes
    pipeTimer = Timer(2, onTick: spawnPipes, repeat: true);
  }

  void increaseScore() {
    score += 1;
    scoreText.text = '$score';
  }

  void resetScore() {
    score = 0;
    scoreText.text = '$score';
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
    resetScore();

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
    final pipeWidth = 60.0;
    final pipeMinHeight = 50.0;

    // Dynamische Lückengröße je nach Score (je höher, desto schwerer)
    double getGapHeight() {
      if (score < 5) return 250.0;
      if (score < 10) return 220.0;
      if (score < 20) return 200.0;
      return 180.0; // Schwer
    }

    final gapHeight = getGapHeight();

    // Berechne zufällige Y-Position für die Lücke
    final maxGapStart = size.y - gapHeight - pipeMinHeight;
    final gapY = pipeMinHeight + random.nextDouble() * maxGapStart;

    // Obere Pipe
    final topPipe = Pipe(
      position: Vector2(size.x, 0),
      isTop: true,
    )..size = Vector2(pipeWidth, gapY);

    // Untere Pipe
    final bottomPipe = Pipe(
      position: Vector2(size.x, gapY + gapHeight),
      isTop: false,
    )..size = Vector2(pipeWidth, size.y - (gapY + gapHeight));

    add(topPipe);
    add(bottomPipe);

    // Dynamischer Abstand zur nächsten Pipe: je schwieriger die Lücke, desto länger warten
    final difficulty = (gapY - size.y / 3).abs(); // Wie weit ist Lücke von Mitte entfernt?
    final normalized = difficulty / (size.y / 2); // 0 (leicht) bis 1 (extrem)
    final delay = 1.4 + normalized * 1.2; // 1.4s bis 2.6s

    pipeTimer.stop();
    pipeTimer = Timer(delay, onTick: spawnPipes, repeat: true);
    pipeTimer.start();
  }


}
