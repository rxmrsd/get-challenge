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

class _CardGameScreenState extends State<CardGameScreen> with SingleTickerProviderStateMixin {
  int? winningCardIndex;
  int attempts = 0;
  List<bool> revealed = List.generate(5, (_) => false);
  bool isGameOver = false;
  int? selectedCardIndex;
  late AnimationController _controller;
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // 各カードのアニメーションを作成
    for (int i = 0; i < 5; i++) {
      _animations.add(Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initializeGame() {
    _controller.reset();  // アニメーションをリセット
    setState(() {
      winningCardIndex = Random().nextInt(5);
      revealed = List.filled(5, false);
      attempts = 0;
      isGameOver = false;
      selectedCardIndex = null;
    });
  }

  void handleCardTap(int index) {
    if (revealed[index] || isGameOver) return;

    selectedCardIndex = index;
    _controller.forward().then((_) {
      setState(() {
        revealed = List.filled(5, true);
        attempts++;
        isGameOver = true;
      });
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
        width: 100,
        height: 140,
        child: GestureDetector(
          onTap: () => handleCardTap(index),
          child: AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final angle = _animations[index].value * pi;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: Card(
                  elevation: 5,
                  color: revealed[index] ? Colors.white : Colors.blue,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: angle < pi / 2
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image.asset(
                                  'assets/images/ball.jpg',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Transform(
                                transform: Matrix4.identity()..rotateY(pi),
                                alignment: Alignment.center,
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
                                    : Container(),
                              ),
                      ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}