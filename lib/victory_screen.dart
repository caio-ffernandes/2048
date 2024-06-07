import 'package:flutter/material.dart';

class VictoryScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;
  final VoidCallback onContinue;

  const VictoryScreen({
    required this.score,
    required this.onRestart,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You Win!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Congratulations!', style: TextStyle(fontSize: 24)),
            Text('Score: $score', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRestart,
              child: Text('New Game'),
            ),
            ElevatedButton(
              onPressed: onContinue,
              child: Text('Continue Playing'),
            ),
          ],
        ),
      ),
    );
  }
}
