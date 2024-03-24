import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minesweeper/utils/mines_state.dart';
import 'package:minesweeper/widgets/flags_widget.dart';
import 'package:minesweeper/widgets/heading_widget.dart';
import 'package:minesweeper/widgets/time_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var mines = Mines();
  bool gamelost = false;
  bool gamewin = false;
  bool showingmines = false;
  int time = 0;
  int flagsTotal = 10;
  late List<List<bool>> clickedStates;
  late List<List<bool>> flagedStates;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    mines.setMines();
    mines.setIndicators();
    initializeClickedStates();
    initializeFlagedStates();
    timeStart();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void initializeClickedStates() {
    clickedStates = List.generate(
      mines.minesState.length,
      (_) => List.generate(mines.minesState.length, (_) => false),
    );
  }

  void initializeFlagedStates() {
    flagedStates = List.generate(
      mines.minesState.length,
      (_) => List.generate(mines.minesState.length, (_) => false),
    );
  }

  void clickTile(int x, int y) {
    setState(() {
      if (!clickedStates[x][y] && !gameEnded()) {
        clickedStates[x][y] = true;
        if (mines.minesState[x][y] == 'X') {
          showAllMines();
          gamelost = true;
          timer.cancel();
        } else if (mines.minesState[x][y] == '0') {
          openAdjacentTiles(x, y);
        } else if (playerWin()) {
          gamewin = true;
          timer.cancel();
        }
      }
    });
  }

  void flagTile(int x, int y) {
    setState(() {
      if (!gameEnded()) {
        flagedStates[x][y] = !flagedStates[x][y];
        flagsCounter();
      }
    });
  }

  void resetBoard() {
    if (!showingmines) {
      setState(() {
        gamelost = false;
        gamewin = false;
        mines.minesState = List.generate(8, (_) => List.filled(8, '0'));
        mines.setMines();
        mines.setIndicators();
        initializeClickedStates();
        initializeFlagedStates();
        time = 0;
        flagsTotal = 10;
        timer.cancel();
        timeStart();
      });
    }
  }

  bool gameEnded() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (mines.minesState[i][j] == 'X' && clickedStates[i][j]) {
          return true;
        }
      }
    }
    return false;
  }

  void showAllMines() async {
    showingmines = true;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (mines.minesState[i][j] == 'X') {
          await Future.delayed(const Duration(milliseconds: 30), () {
            setState(() {
              clickedStates[i][j] = true;
            });
          });
        }
      }
    }
    showingmines = false;
  }

  bool playerWin() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (mines.minesState[i][j] == 'X' && !flagedStates[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  void openAdjacentTiles(int x, int y) {
    Queue<List<int>> queue = Queue();
    queue.add([x, y]);

    while (queue.isNotEmpty) {
      List<int> current = queue.removeFirst();
      int currentX = current[0];
      int currentY = current[1];

      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          int newX = currentX + dx;
          int newY = currentY + dy;
          if (newX >= 0 &&
              newX < 8 &&
              newY >= 0 &&
              newY < 8 &&
              !clickedStates[newX][newY] &&
              mines.minesState[newX][newY] != 'X') {
            clickedStates[newX][newY] = true;
            if (mines.minesState[newX][newY] == '0') {
              queue.add([newX, newY]);
            }
          }
        }
      }
    }
  }

  void flagsCounter() {
    setState(() {
      flagsTotal = 10;
      int howMany = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (flagedStates[i][j]) {
            howMany += 1;
          }
        }
      }
      flagsTotal -= howMany;
    });
  }

  void timeStart() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        time++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(54, 65, 86, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              HeadingWidget(
                gameLost: gamelost,
                gameWin: gamewin,
              ),
              const SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TimerWidget(time: time),
                  FlagsWidget(flagsTotal: flagsTotal),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: mines.minesState.length),
                    itemCount:
                        mines.minesState.length * mines.minesState.length,
                    itemBuilder: (context, index) {
                      int x, y = 0;
                      x = (index / mines.minesState.length).floor();
                      y = (index % mines.minesState.length);
                      return GridTile(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: GestureDetector(
                            child: Container(
                              color: const Color.fromRGBO(33, 45, 64, 1),
                              child: Center(
                                child: clickedStates[x][y]
                                    ? mines.minesState[x][y] == 'X'
                                        ? const Icon(
                                            Icons.circle,
                                            color: Colors.red,
                                          )
                                        : mines.minesState[x][y] == '1'
                                            ? Text(
                                                mines.minesState[x][y],
                                                style: GoogleFonts.bebasNeue(
                                                  fontSize: 25,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            : mines.minesState[x][y] == '2'
                                                ? Text(
                                                    mines.minesState[x][y],
                                                    style:
                                                        GoogleFonts.bebasNeue(
                                                      fontSize: 25,
                                                      color: Colors.green,
                                                    ),
                                                  )
                                                : mines.minesState[x][y] == '3'
                                                    ? Text(
                                                        mines.minesState[x][y],
                                                        style: GoogleFonts
                                                            .bebasNeue(
                                                          fontSize: 25,
                                                          color:
                                                              Colors.red[400],
                                                        ),
                                                      )
                                                    : mines.minesState[x][y] ==
                                                            '4'
                                                        ? Text(
                                                            mines.minesState[x]
                                                                [y],
                                                            style: GoogleFonts
                                                                .bebasNeue(
                                                              fontSize: 25,
                                                              color:
                                                                  Colors.purple,
                                                            ),
                                                          )
                                                        : mines.minesState[x]
                                                                    [y] ==
                                                                '0'
                                                            ? Expanded(
                                                                child:
                                                                    Container(
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    54,
                                                                    65,
                                                                    86,
                                                                    1),
                                                              ))
                                                            : Text(
                                                                mines.minesState[
                                                                    x][y],
                                                                style: GoogleFonts
                                                                    .bebasNeue(
                                                                  fontSize: 25,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              )
                                    : flagedStates[x][y]
                                        ? const Icon(
                                            Icons.flag,
                                            color: Colors.red,
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            onTap: () => clickTile(x, y),
                            onLongPress: () => flagTile(x, y),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              FilledButton(
                onPressed: () => resetBoard(),
                style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(33, 45, 64, 1),
                    minimumSize: const Size(double.maxFinite, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Text(
                  'Reset',
                  style:
                      GoogleFonts.bebasNeue(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
