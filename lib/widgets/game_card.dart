import 'package:flutter/material.dart';
import 'dart:math';

class GameCard extends StatelessWidget {
  final int index;
  final Animation<double> animation;
  final bool revealed;
  final bool isWinning;
  final bool isSelected;
  final Function(int) onTap;

  const GameCard({
    Key? key,
    required this.index,
    required this.animation,
    required this.revealed,
    required this.isWinning,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 95,
        height: 140,
        child: GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final angle = animation.value * pi;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: _buildCardContent(angle),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(double angle) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: angle < pi / 2
                ? _buildCardBack()
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildCardFront(),
                  ),
          ),
          if (revealed && isSelected)
            _buildGetMark(angle),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'assets/images/ball.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCardFront() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: isWinning
          ? Image.asset(
              'assets/images/pika.jpg',
              fit: BoxFit.cover,
            )
          : Center(
              child: Text(
                '×',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Widget _buildGetMark(double angle) {
    return Positioned(
      left: 5,
      top: 5,
      child: Transform(
        transform: Matrix4.identity()..rotateY(-angle),
        alignment: Alignment.center,
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
    );
  }
}