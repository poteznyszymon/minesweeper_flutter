import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingWidget extends StatefulWidget {
  final bool gameLost;
  final bool gameWin;
  const HeadingWidget(
      {super.key, required this.gameLost, required this.gameWin});

  @override
  State<HeadingWidget> createState() => _HeadingWidgetState();
}

class _HeadingWidgetState extends State<HeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(33, 45, 64, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
            widget.gameLost
                ? 'GAME LOST'
                : widget.gameWin
                    ? 'GAME WON'
                    : 'MINE SWEEPER',
            style: GoogleFonts.bebasNeue(fontSize: 40, color: Colors.white)),
      ),
    );
  }
}
