import 'package:flutter/material.dart';
import 'dart:math';
import 'game_card.dart';

class CardGrid extends StatefulWidget {
  final Function onGameOver;
  final bool isGameOver;

  const CardGrid({
    Key? key,
    required this.onGameOver,
    required this.isGameOver,
  }) : super(key: key);

  @override
  CardGridState createState() => CardGridState();
}

class CardGridState extends State<CardGrid> with SingleTickerProviderStateMixin {
  int? winningCardIndex;
  List<bool> revealed = List.generate(5, (_) => false);
  int? selectedCardIndex;
  late AnimationController _controller;
  final List<Animation<double>> _animations = [];
  bool _isAnimating = false;
  bool _wasReset = false;  // 追加: リセット状態を追跡

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    for (int i = 0; i < 5; i++) {
      _animations.add(Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
        ),
      ));
    }

    initializeGame();
  }

  @override
  void didUpdateWidget(CardGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // shouldResetがtrueからfalseに変わった時のみ初期化
    if (oldWidget.isGameOver && !widget.isGameOver && !_wasReset) {
      _wasReset = true;
      initializeGame();
    } else if (!oldWidget.isGameOver && !widget.isGameOver) {
      _wasReset = false;
    }
  }

  void handleCardTap(int index) {
    if (revealed[index] || _isAnimating || widget.isGameOver) return;

    setState(() {
      _isAnimating = true;
      selectedCardIndex = index;
    });

    _controller.forward().then((_) {
      setState(() {
        revealed = List.filled(5, true);
        _isAnimating = false;
        widget.onGameOver();
      });
    });
  }

  void initializeGame() {
    setState(() {
      winningCardIndex = Random().nextInt(5);
      revealed = List.filled(5, false);
      selectedCardIndex = null;
      _isAnimating = false;
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => 
              GameCard(
                index: index,
                animation: _animations[index],
                revealed: revealed[index],
                isWinning: index == winningCardIndex,
                isSelected: index == selectedCardIndex,
                onTap: handleCardTap,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) => 
              GameCard(
                index: index + 3,
                animation: _animations[index + 3],
                revealed: revealed[index + 3],
                isWinning: index + 3 == winningCardIndex,
                isSelected: index + 3 == selectedCardIndex,
                onTap: handleCardTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}