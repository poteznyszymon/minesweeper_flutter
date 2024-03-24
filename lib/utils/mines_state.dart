import 'dart:math';

class Mines {
  List<List<String>> minesState = [
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
  ];

  void setMines() {
    Random random = Random();
    int bombsPlaced = 0;
    while (bombsPlaced < 10) {
      int x = random.nextInt(8);
      int y = random.nextInt(8);
      if (minesState[y][x] != 'X') {
        minesState[y][x] = 'X';
        bombsPlaced++;
      }
    }
  }

  void setIndicators() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (minesState[i][j] == 'X') {
          continue;
        }
        int count = 0;
        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            int ny = i + dy;
            int nx = j + dx;
            if (0 <= ny &&
                ny < 8 &&
                0 <= nx &&
                nx < 8 &&
                minesState[ny][nx] == 'X') {
              count++;
            }
          }
        }
        minesState[i][j] = count.toString();
      }
    }
  }
}
