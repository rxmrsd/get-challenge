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
  bool isGameOver = false;
  int? selectedCardIndex;  // 追加: 選択したカードのインデックスを保存

  void initializeGame() {
    setState(() {
      winningCardIndex = Random().nextInt(5);
      revealed = List.filled(5, false);
      attempts = 0;
      isGameOver = false;
      selectedCardIndex = null;  // 追加: 選択カードをリセット
    });
  }

  void handleCardTap(int index) {
    if (revealed[index] || isGameOver) return;

    setState(() {
      revealed = List.filled(5, true);
      attempts++;
      isGameOver = true;
      selectedCardIndex = index;  // 追加: 選択したカードを記録
    });
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
                    SizedBox(height: 16),
                    // 下段の2枚
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) => _buildCard(index + 3)),
                    ),
                  ],
                ),
              ),
            ),
            if (isGameOver)  // 追加: ゲーム終了時のみRetryボタンを表示
              ElevatedButton(
                onPressed: initializeGame,
                child: Text('Retry'),
              ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 95,
        height: 140,
        child: GestureDetector(
          onTap: () => handleCardTap(index),
          child: Card(
            elevation: 5,
            color: revealed[index] ? Colors.white : Colors.blue,
            child: Stack(  // 追加: Stackを使用してGETマークを重ねる
              children: [
                ClipRRect(
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
                          : Center(child: Text('×')))
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            'assets/images/ball.jpg',  // 裏面の画像
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                // 追加: 選択したカードが当たりの場合にGETマークを表示
                if (revealed[index] && index == selectedCardIndex)
                  Positioned(
                    left: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'GET',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}