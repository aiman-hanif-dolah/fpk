import 'package:flutter/material.dart';
import 'game.dart';

class QuestionOverlay extends StatelessWidget {
  final MyGame game;
  QuestionOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    final question = game.currentQuestion!;
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ...List.generate(question.options.length, (i) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ElevatedButton(
                  onPressed: () {
                    game.answerQuestion(i);
                    game.overlays.remove('QuestionOverlay');
                    game.resumeEngine();
                  },
                  child: Text(
                    question.options[i],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
