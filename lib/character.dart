import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'game.dart';

class Character extends SpriteComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final String runImage;
  final String jumpImage;

  bool  isOnGround = true;
  double vy         = 0.0;
  int    moveDir    = 0;            // -1=left, 0=stop, +1=right
  static const double runSpeed  = 200;
  static const double gravity   = 800;
  static const double jumpPower = -400;

  Character({
    required this.runImage,
    required this.jumpImage,
    required Vector2 position,
  }): super(position: position, size: Vector2(64,64), anchor: Anchor.bottomCenter);

  late Sprite runSprite;
  late Sprite jumpSprite;

  @override
  Future<void> onLoad() async {
    runSprite  = await game.loadSprite(runImage);
    jumpSprite = await game.loadSprite(jumpImage);
    sprite     = runSprite;
    add(RectangleHitbox());
  }

  // Called by the buttons:
  void moveLeft()  => moveDir = -1;
  void moveRight() => moveDir = +1;
  void stopHorizontal() => moveDir = 0;
  void jump() {
    if (isOnGround) {
      vy = jumpPower;
      isOnGround = false;
      sprite = jumpSprite;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // horizontal movement
    x += moveDir * runSpeed * dt;
    // clamp inside world (8 screens wide)
    x = x.clamp(0, game.size.x * 8);

    // vertical / gravity / sprite swap
    if (!isOnGround) {
      vy += gravity * dt;
      y  += vy * dt;
      if (y >= game.size.y) {
        y = game.size.y;
        isOnGround = true;
        vy = 0.0;
        sprite = runSprite;
      }
    } else {
      sprite = runSprite;
    }
  }
}
