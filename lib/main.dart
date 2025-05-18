import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'game.dart';
import 'question_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permainan FPK & Kepimpinan',
      home: Scaffold(
        body: GameWidget<MyGame>(
          game: MyGame(),
          overlayBuilderMap: {
            'QuestionOverlay': (_, MyGame game) => QuestionOverlay(game: game),
          },
        ),
      ),
    );
  }
}
