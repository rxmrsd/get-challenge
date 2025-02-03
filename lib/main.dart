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
      // 全てのカードを表にする
      revealed = List.filled(5, true);
      attempts++;
      
      if (index == winningCardIndex) {
        showResultDialog('Success!');
      } else {
        showResultDialog('Game Over');
      }
    });
  }

  void showResultDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // 背景タップでダイアログを閉じないように
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 上段の3枚
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => _buildCard(index)),
                    ),
                    SizedBox(height: 16), // 上下の行間
                    // 下段の2枚
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) => _buildCard(index + 3)),
                    ),
                  ],
                ),
              ),
            ),
            Text('Attempts: $attempts'),
            ElevatedButton(
              onPressed: initializeGame,
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        height: 140,
        child: GestureDetector(
          onTap: () => handleCardTap(index),
          child: Card(
            elevation: 5,
            color: revealed[index] ? Colors.white : Colors.blue,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: revealed[index]
                  ? (index == winningCardIndex 
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            'assets/images/pika.jpg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(child: Text('LOSE')))
                  : Center(child: Icon(Icons.question_mark)),
            ),
          ),
        ),
      ),
    );
  }
}