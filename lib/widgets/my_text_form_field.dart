import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/text_field_focused_provider.dart';

class MyTextFormField extends StatelessWidget {
   final String label;
   final void Function(bool)? onFocusChange;
   final bool borderColor;
   final bool isPassword;
   final TextInputType textInputType;
   final TextEditingController? textEditingController;
   final void Function()? onPressedPasswordToggle;
   final String? initialValue;
   final bool? enabled;
  const MyTextFormField({super.key, required this.label,required this.onFocusChange, required this.borderColor, required this.isPassword, required this.textInputType, this.textEditingController,this.onPressedPasswordToggle,this.initialValue, this.enabled});
  @override
  Widget build(BuildContext context) {
    return Consumer<TextFieldFocusProvider>(
      builder: (context, textFieldFocus, child) => Focus(
        onFocusChange: onFocusChange,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                  color:borderColor ? Colors.black : Colors.black26
              ),
              borderRadius: BorderRadius.circular(10)
          ),

            child: TextFormField(
              style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w400),
              controller: textEditingController,
              decoration: InputDecoration(
                label: Text(label),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelStyle: GoogleFonts.poppins(
                    color: Colors.black38,
                    fontSize: 15,
                    fontWeight: FontWeight.normal
                ),
                suffixIcon:isPassword ? IconButton(onPressed: onPressedPasswordToggle,
                    icon:Icon(textFieldFocus.passwordToggle ? Icons.visibility : Icons.visibility_off)) :null
              ),
              cursorColor: Colors.black,
              obscureText:isPassword ? textFieldFocus.passwordToggle : false,
              keyboardType: textInputType,
              initialValue: initialValue,
              enabled: enabled,
            ),
        ),
      ),
    );
  }
}
