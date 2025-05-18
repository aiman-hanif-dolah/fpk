import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/camera.dart';
import 'package:flutter/material.dart';

import 'question_data.dart';
import 'character.dart';
import 'coin.dart';
import 'checkpoint.dart';

class MyGame extends FlameGame
    with HasCollisionDetection, MultiTouchDragDetector, MultiTouchTapDetector {
  // WORLD
  late Character      hero;
  late List<Question> questions;
  Question?           currentQuestion;
  int                 answeredCount = 0;
  int                 currentSegment = 1;
  int                 score          = 0;

  // HUD BUTTONS
  late HudButtonComponent leftBtn;
  late HudButtonComponent rightBtn;
  late HudButtonComponent jumpBtn;
  late TextComponent     scoreText;

  @override
  Future<void> onLoad() async {
    // 1) Preload sprites
    await images.loadAll([
      'level1_bg.png',
      'level2_bg.png',
      'hero_run.png',
      'hero_jump.png',
      'horse_run.png',
      'horse_jump.png',
      'coin.png',
    ]);

    // 2) Load level one into the world
    await _initLevel1();

    // 3) Create D-Pad buttons and add to viewport (HUD)
    // a) Left button
    leftBtn = HudButtonComponent(
      button: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.black26,
      ),
      buttonDown: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.black45,
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
      onPressed: () => hero.moveLeft(),
      onReleased: () => hero.stopHorizontal(),
    )..priority = 10;
    camera.viewport.add(leftBtn);

    // b) Right button
    rightBtn = HudButtonComponent(
      button: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.black26,
      ),
      buttonDown: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.black45,
      ),
      margin: const EdgeInsets.only(left: 80, bottom: 20),
      onPressed: () => hero.moveRight(),
      onReleased: () => hero.stopHorizontal(),
    )..priority = 10;
    camera.viewport.add(rightBtn);

    // c) Jump button
    jumpBtn = HudButtonComponent(
      button: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.black26,
      ),
      buttonDown: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.black45,
      ),
      margin: const EdgeInsets.only(right: 20, bottom: 20),
      onPressed: () => hero.jump(),
      onReleased: () {}, // nothing needed on release
    )..priority = 10;
    camera.viewport.add(jumpBtn);

    // 4) Score text (HUD)
    scoreText = TextComponent(
      text: 'Skor: $score',
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    )..priority = 11;
    camera.viewport.add(scoreText);
  }

  Future<void> _initLevel1() async {
    currentSegment = 1;
    answeredCount  = 0;
    questions      = questionsSeg1;
    score          = 0;

    // background
    final bg = await Parallax.load(
      [ParallaxImageData('level1_bg.png')],
      repeat: ImageRepeat.repeatX,
    );
    add(ParallaxComponent(parallax: bg));

    // hero
    hero = Character(
      runImage:  'hero_run.png',
      jumpImage: 'hero_jump.png',
      position:  Vector2(100, size.y),
    );
    add(hero);

    // camera
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(size.x, size.y),
    );
    camera.follow(hero);

    // coins & checkpoints
    _addLevel1Items();
  }

  void _addLevel1Items() {
    for (final x in [200,400,600,800,1000,1200]) {
      add(Coin(Vector2(x.toDouble(), size.y)));
    }
    final cpXs = [500,1000,1500,2000,2500,3000,3500,4000];
    for (var i = 0; i < cpXs.length; i++) {
      add(Checkpoint(Vector2(cpXs[i].toDouble(), size.y), i));
    }
  }

  Future<void> startLevel2() async {
    currentSegment = 2;
    answeredCount  = 0;
    questions      = questionsSeg2;

    // clear world, keep HUD
    final toRemove = children.where((c) =>
    c != leftBtn &&
        c != rightBtn &&
        c != jumpBtn &&
        c != scoreText
    ).toList();
    for (final c in toRemove) c.removeFromParent();

    // new bg
    final bg2 = await Parallax.load(
      [ParallaxImageData('level2_bg.png')],
      repeat: ImageRepeat.repeatX,
    );
    add(ParallaxComponent(parallax: bg2));

    // new hero (horse)
    hero = Character(
      runImage:  'horse_run.png',
      jumpImage: 'horse_jump.png',
      position:  Vector2(100, size.y),
    );
    add(hero);

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(size.x, size.y),
    );
    camera.follow(hero);

    _addLevel2Items();
  }

  void _addLevel2Items() {
    for (final x in [200,600,1000,1400,1800]) {
      add(Coin(Vector2(x.toDouble(), size.y)));
    }
    final cpXs = [800,1600,2400,3200,4000];
    for (var i = 0; i < cpXs.length; i++) {
      add(Checkpoint(Vector2(cpXs[i].toDouble(), size.y), i));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = 'Skor: $score';
  }

  // Called by your QuestionOverlay:
  void answerQuestion(int choiceIndex) {
    if (choiceIndex == currentQuestion?.correctOption) {
      score += 10;
    }
    answeredCount++;
    if (answeredCount >= questions.length) {
      if (currentSegment == 1) {
        startLevel2();
      } else {
        // finished
      }
    }
  }
}
