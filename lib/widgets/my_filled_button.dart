import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class MyFilledButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const MyFilledButton({Key? key, required this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 10)),
          backgroundColor:
          MaterialStateProperty.all(blueColor),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(50)))),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 18),
      ),
    );
  }
}
