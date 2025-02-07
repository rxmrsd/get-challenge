import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final bool isGameOver;
  final VoidCallback onRetry;

  const RetryButton({
    Key? key,
    required this.isGameOver,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: isGameOver
          ? ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry'),
            )
          : null,
    );
  }
}