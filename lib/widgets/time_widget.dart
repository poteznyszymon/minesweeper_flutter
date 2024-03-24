import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerWidget extends StatelessWidget {
  final int time;

  const TimerWidget({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.timer,
          size: 30,
          color: Colors.white,
        ),
        const SizedBox(width: 5),
        Text(
          time.toString(),
          style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white),
        )
      ],
    );
  }
}
