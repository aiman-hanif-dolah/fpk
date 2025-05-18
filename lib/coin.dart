import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'character.dart';
import 'game.dart';

class Coin extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  Coin(Vector2 position)
      : super(position: position, size: Vector2(32, 32), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('coin.png');
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Character) {
      // Tambah mata dan padam coin
      gameRef.score += 5;
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
