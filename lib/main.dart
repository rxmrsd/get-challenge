import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CardGameScreen());
  }
}

class CardGameScreen extends StatefulWidget {
  @override
  _CardGameScreenState createState() => _CardGameScreenState();
}

class _CardGameScreenState extends State<CardGameScreen> {
  int? winningCardIndex;
  int attempts = 0;
  List<bool> revealed = List.generate(5, (_) => false);

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    setState(() {
      winningCardIndex = Random().nextInt(5);
      revealed = List.filled(5, false);
      attempts = 0;
    });
  }

  void handleCardTap(int index) {
    if (revealed[index]) return;

    setState(() {
      revealed[index] = true;
      attempts++;
      
      if (index == winningCardIndex) {
        showResultDialog('Success!');
      } else if (attempts >= 3) {
        showResultDialog('Game Over');
      }
    });
  }

  void showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              initializeGame();
            },
            child: Text('Retry'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Game')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () => handleCardTap(index),
                child: Card(
                  color: revealed[index]
                      ? (index == winningCardIndex ? Colors.green : Colors.red)
                      : Colors.blue,
                  child: Center(
                    child: revealed[index]
                        ? Text(index == winningCardIndex ? 'WIN' : 'LOSE')
                        : Icon(Icons.question_mark),
                  ),
                ),
              ),
              itemCount: 5,
            ),
          ),
          Text('Attempts: $attempts'),
          ElevatedButton(
            onPressed: initializeGame,
            child: Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}