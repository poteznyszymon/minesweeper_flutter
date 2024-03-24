import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlagsWidget extends StatelessWidget {
  final int flagsTotal;
  const FlagsWidget({super.key, required this.flagsTotal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.flag,
          size: 30,
          color: Colors.white,
        ),
        const SizedBox(width: 5),
        Text(
          flagsTotal.toString(),
          style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white),
        )
      ],
    );
  }
}
