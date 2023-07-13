import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/provider/text_field_focused_provider.dart';
import 'package:instagram_clone/screens/signup_email_screen.dart';
import 'package:instagram_clone/widgets/my_filled_button.dart';
import 'package:instagram_clone/widgets/my_outlined_button.dart';
import 'package:instagram_clone/widgets/my_text_form_field.dart';
import 'package:provider/provider.dart';

class SignUpNumberScreen extends StatefulWidget {
  const SignUpNumberScreen({Key? key}) : super(key: key);

  @override
  State<SignUpNumberScreen> createState() => _SignUpNumberScreenState();
}

class _SignUpNumberScreenState extends State<SignUpNumberScreen> {
  final TextEditingController _numberTextEditingController = TextEditingController();


  @override
  void dispose() {
    _numberTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TextFieldFocusProvider>(
      builder: (context, textFieldFocus, child) => Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 20 , top: 20 ,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: (){Navigator.pop(context);},
                          child: const Icon(Icons.arrow_back_rounded))
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Text('What\'s your mobile number?',
                  style: GoogleFonts.poppins(fontSize: 23,fontWeight: FontWeight.w500,letterSpacing: -1),
                ),
                Text('Enter the mobile number where you can be contacted. No one will see this on your profile.',
                  style: GoogleFonts.poppins(fontSize: 16 , letterSpacing: -1,color: Colors.black54),
                ),
                const SizedBox(height: 20,),
                MyTextFormField(label: 'mobile number',
                    onFocusChange: (value){
                  // perform same functionality
                  textFieldFocus.emailFocus = value;
                    }, borderColor: textFieldFocus.emailFocus,
                    isPassword: false,
                    textInputType: TextInputType.phone,
                    textEditingController: _numberTextEditingController),
                Text('You may receive SMS notifications from us for security and login purposes.',
                  style: GoogleFonts.poppins(fontSize: 15 , letterSpacing: -1 , color: Colors.black38 ),
                ),
                const SizedBox(height: 15),
                const MyFilledButton(title: 'Next'),
                const SizedBox(height: 15,),
                MyOutlinedButton(title: 'Sign up with email',onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpEmailScreen(),));
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
