import 'package:flutter/material.dart';
import '../widgets/card_grid.dart';

class CardGameScreen extends StatefulWidget {
  const CardGameScreen({super.key});

  @override
  CardGameScreenState createState() => CardGameScreenState();
}

class CardGameScreenState extends State<CardGameScreen> {
  bool isGameOver = false;
  int attempts = 0;
  Key _cardGridKey = UniqueKey();  // 追加: CardGridのKeyを管理

  void handleGameOver() {
    setState(() {
      isGameOver = true;
      attempts++;
    });
  }

  void handleRetry() {
    setState(() {
      isGameOver = false;
      _cardGridKey = UniqueKey();  // 追加: 新しいKeyを生成
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get Challenge!!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: CardGrid(
                key: _cardGridKey,  // 追加: Keyを設定
                onGameOver: handleGameOver,
                isGameOver: isGameOver,
              ),
            ),
            SizedBox(
              height: 48,
              child: isGameOver
                ? ElevatedButton(
                    onPressed: handleRetry,
                    child: Text('Retry'),
                  )
                : null,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}