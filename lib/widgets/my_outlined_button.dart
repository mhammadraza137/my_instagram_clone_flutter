import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class MyOutlinedButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const MyOutlinedButton({Key? key, required this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(
                        width: 1, color: blueColor)))),
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18),
        ));
  }
}
