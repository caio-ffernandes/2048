import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;

  const GameOverScreen({
    required this.score,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Game Over', style: TextStyle(fontSize: 24)),
            Text('Score: $score', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRestart,
              child: Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
