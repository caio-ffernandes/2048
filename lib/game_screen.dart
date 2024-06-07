import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'victory_screen.dart';
import 'game_over_screen.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<int>> _board;
  int _score = 0;
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _board = List.generate(4, (i) => List.generate(4, (j) => 0));
    _addNewTile();
    _addNewTile();
    _loadHighScore();
  }

  _loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = (prefs.getInt('highScore') ?? 0);
    });
  }

  void _addNewTile() {
    List<Offset> emptyTiles = [];
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (_board[row][col] == 0) {
          emptyTiles.add(Offset(row.toDouble(), col.toDouble()));
        }
      }
    }
    if (emptyTiles.isNotEmpty) {
      final random = Random();
      Offset randomTile = emptyTiles[random.nextInt(emptyTiles.length)];
      _board[randomTile.dx.toInt()][randomTile.dy.toInt()] = random.nextInt(10) == 0 ? 4 : 2;
    }
  }

  void _moveTiles(Direction direction) {
    setState(() {
      bool moved = false;
      switch (direction) {
        case Direction.up:
          for (int col = 0; col < 4; col++) {
            List<int> column = [0, 0, 0, 0];
            int index = 0;
            for (int row = 0; row < 4; row++) {
              if (_board[row][col] != 0) {
                column[index++] = _board[row][col];
              }
            }
            for (int i = 0; i < 3; i++) {
              if (column[i] != 0 && column[i] == column[i + 1]) {
                column[i] *= 2;
                _score += column[i];
                column.removeAt(i + 1);
                column.add(0);
              }
            }
            for (int row = 0; row < 4; row++) {
              if (_board[row][col] != column[row]) {
                moved = true;
                _board[row][col] = column[row];
              }
            }
          }
          break;
        case Direction.down:
          for (int col = 0; col < 4; col++) {
            List<int> column = [0, 0, 0, 0];
            int index = 0;
            for (int row = 3; row >= 0; row--) {
              if (_board[row][col] != 0) {
                column[index++] = _board[row][col];
              }
            }
            for (int i = 0; i < 3; i++) {
              if (column[i] != 0 && column[i] == column[i + 1]) {
                column[i] *= 2;
                _score += column[i];
                column.removeAt(i + 1);
                column.add(0);
              }
            }
            for (int row = 3; row >= 0; row--) {
              if (_board[row][col] != column[3 - row]) {
                moved = true;
                _board[row][col] = column[3 - row];
              }
            }
          }
          break;
        case Direction.left:
          for (int row = 0; row < 4; row++) {
            List<int> line = [0, 0, 0, 0];
            int index = 0;
            for (int col = 0; col < 4; col++) {
              if (_board[row][col] != 0) {
                line[index++] = _board[row][col];
              }
            }
            for (int i = 0; i < 3; i++) {
              if (line[i] != 0 && line[i] == line[i + 1]) {
                line[i] *= 2;
                _score += line[i];
                line.removeAt(i + 1);
                line.add(0);
              }
            }
            for (int col = 0; col < 4; col++) {
              if (_board[row][col] != line[col]) {
                moved = true;
                _board[row][col] = line[col];
              }
            }
          }
          break;
        case Direction.right:
          for (int row = 0; row < 4; row++) {
            List<int> line = [0, 0, 0, 0];
            int index = 0;
            for (int col = 3; col >= 0; col--) {
              if (_board[row][col] != 0) {
                line[index++] = _board[row][col];
              }
            }
            for (int i = 0; i < 3; i++) {
              if (line[i] != 0 && line[i] == line[i + 1]) {
                line[i] *= 2;
                _score += line[i];
                line.removeAt(i + 1);
                line.add(0);
              }
            }
            for (int col = 3; col >= 0; col--) {
              if (_board[row][col] != line[3 - col]) {
                moved = true;
                _board[row][col] = line[3 - col];
              }
            }
          }
          break;
      }
      if (moved) {
        _addNewTile();
        _updateHighScore();
        _checkWin();
        _checkGameOver();
      }
    });
  }

  void _checkGameOver() {
    bool gameOver = true;
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (_board[row][col] == 0 ||
            (row > 0 && _board[row][col] == _board[row - 1][col]) ||
            (row < 3 && _board[row][col] == _board[row + 1][col]) ||
            (col > 0 && _board[row][col] == _board[row][col - 1]) ||
            (col < 3 && _board[row][col] == _board[row][col + 1])) {
          gameOver = false;
          break;
        }
      }
    }
    if (gameOver) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(
            score: _score,
            onRestart: () {
              Navigator.of(context).pop();
              _initializeGame();
            },
          ),
        ),
      );
    }
  }

  void _checkWin() {
    bool hasWon = false;
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (_board[row][col] == 2048) {
          hasWon = true;
          break;
        }
      }
    }
    if (hasWon) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VictoryScreen(
            score: _score,
            onRestart: () {
              Navigator.of(context).pop();
              _initializeGame();
            },
            onContinue: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  void _updateHighScore() async {
    if (_score > _highScore) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', _score);
      setState(() {
        _highScore = _score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2048 Game'),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _moveTiles(Direction.up);
            } else if (details.primaryVelocity! > 0) {
              _moveTiles(Direction.down);
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _moveTiles(Direction.left);
            } else if (details.primaryVelocity! > 0) {
              _moveTiles(Direction.right);
            }
          },
          child: Column(
            children: [
              Text('Score: $_score', style: TextStyle(fontSize: 24)),
              Text('High Score: $_highScore', style: TextStyle(fontSize: 24)),
              Container(
                height: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 4;
                    int col = index % 4;
                    return Container(
                      margin: EdgeInsets.all(4),
                      color: _getTileColor(_board[row][col]),
                      child: Center(
                        child: Text(
                          _board[row][col] == 0 ? '' : '${_board[row][col]}',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                  itemCount: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.grey[300]!;
      case 4:
        return Colors.grey[400]!;
      case 8:
        return Colors.orange;
      case 16:
        return Colors.orange[700]!;
      case 32:
        return Colors.red;
      case 64:
        return Colors.red[700]!;
      case 128:
        return Colors.yellow;
      case 256:
        return Colors.yellow[700]!;
      case 512:
        return Colors.green;
      case 1024:
        return Colors.green[700]!;
      case 2048:
        return Colors.blue;
      default:
        return Colors.grey[200]!;
    }
  }
}

enum Direction { up, down, left, right }
