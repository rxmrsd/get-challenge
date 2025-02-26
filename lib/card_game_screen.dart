import 'package:flutter/material.dart';

import '../widgets/card_grid.dart';
import '../widgets/retry_button.dart';

class CardGameScreen extends StatefulWidget {
  const CardGameScreen({super.key});

  @override
  CardGameScreenState createState() => CardGameScreenState();
}

class CardGameScreenState extends State<CardGameScreen> {
  bool isGameOver = false;
  int attempts = 0;

  void handleGameOver(int score, int totalMoves) {
    setState(() {
      isGameOver = true;
      attempts++;
    });
  }

  void handleRetry() {
    setState(() {
      isGameOver = false;
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
                onGameOver: handleGameOver,
                isGameOver: isGameOver,
              ),
            ),
            RetryButton(
              isGameOver: isGameOver,
              onRetry: handleRetry,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
