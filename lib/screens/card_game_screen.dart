import 'package:flutter/material.dart';
import '../widgets/card_grid.dart';
import '../widgets/game_result.dart';

class CardGameScreen extends StatefulWidget {
  const CardGameScreen({super.key});

  @override
  CardGameScreenState createState() => CardGameScreenState();
}

class CardGameScreenState extends State<CardGameScreen> {
  bool isGameOver = false;
  int attempts = 0;
  int wins = 0;  // 追加
  Key _cardGridKey = UniqueKey();
  final List<GameResult> gameResults = [];  // 追加: 結果履歴

  void handleGameOver(int selectedIndex, int winningIndex) {  // パラメータ追加
    final bool isWin = selectedIndex == winningIndex;  // 追加
    setState(() {
      isGameOver = true;
      attempts++;
      if (isWin) wins++;  // 追加
      
      // 結果を記録
      gameResults.add(GameResult(
        selectedIndex: selectedIndex,
        winningIndex: winningIndex,
        isWin: isWin,
        playedAt: DateTime.now(),
      ));
    });
  }

  void handleRetry() {
    setState(() {
      isGameOver = false;
      _cardGridKey = UniqueKey();  // 追加: 新しいKeyを生成
    });
  }

  // リセット処理を行うメソッドを追加
  void resetStats() {
    setState(() {
      attempts = 0;
      wins = 0;
      gameResults.clear();
    });
  }

  // 確認ダイアログを表示するメソッドを追加
  Future<void> showResetConfirmation() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('統計のリセット'),
          content: const Text('すべての記録をリセットしますか？\nこの操作は取り消せません。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('リセット'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      resetStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Challenge!!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: showResetConfirmation,
            tooltip: '統計をリセット',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('試行回数', style: TextStyle(fontSize: 16)),
                        Text('$attempts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('勝率', style: TextStyle(fontSize: 16)),
                        Text(
                          attempts > 0 
                            ? '${((wins / attempts) * 100).toStringAsFixed(1)}%'
                            : '0%',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Spacer(), // 上部の余白
            CardGrid(
              key: _cardGridKey,
              onGameOver: handleGameOver,
              isGameOver: isGameOver,
            ),
            const Spacer(), // 下部の余白
            SizedBox(
              height: 48, // Retryボタンの高さ分のスペースを確保
              child: isGameOver
                ? ElevatedButton(
                    onPressed: handleRetry,
                    child: const Text('もう一度プレイ'),
                  )
                : null,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}