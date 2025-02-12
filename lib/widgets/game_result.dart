class GameResult {
  final int selectedIndex;
  final int winningIndex;
  final bool isWin;
  final DateTime playedAt;

  GameResult({
    required this.selectedIndex,
    required this.winningIndex,
    required this.isWin,
    required this.playedAt,
  });
}