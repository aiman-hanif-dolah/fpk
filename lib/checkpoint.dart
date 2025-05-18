import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'character.dart';
import 'game.dart';

class Checkpoint extends PositionComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final int questionIndex;

  Checkpoint(Vector2 position, this.questionIndex)
      : super(position: position, size: Vector2(10, 100), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Character) {
      // Ceti soalan dan paparkan overlay
      gameRef.pauseEngine();
      gameRef.currentQuestion = gameRef.questions[questionIndex];
      gameRef.overlays.add('QuestionOverlay');
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
