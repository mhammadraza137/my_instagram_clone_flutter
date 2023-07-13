import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/signup_main_screen.dart';
import 'package:provider/provider.dart';
import 'package:email_otp/email_otp.dart';
import '../provider/text_field_focused_provider.dart';
import '../widgets/my_filled_button.dart';
import '../widgets/my_outlined_button.dart';
import '../widgets/my_text_form_field.dart';

class SignupEmailOTPScreen extends StatefulWidget {
  final String userEmail;
  final EmailOTP myAuth;
  const SignupEmailOTPScreen({Key? key, required this.userEmail, required this.myAuth}) : super(key: key);

  @override
  State<SignupEmailOTPScreen> createState() => _SignupEmailOTPScreenState();
}

class _SignupEmailOTPScreenState extends State<SignupEmailOTPScreen> {
  final TextEditingController _otpTextEditingController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _otpTextEditingController.dispose();
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
                        child: const Icon(Icons.arrow_back_rounded),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Text('Enter the confirmation code',
                  style: GoogleFonts.poppins(fontSize: 23,fontWeight: FontWeight.w500,letterSpacing: -1),
                ),
                Text('To confirm your account\, enter the 6-digit code we sent to ${widget.userEmail}',
                  style: GoogleFonts.poppins(fontSize: 16 , letterSpacing: -1,color: Colors.black54),
                ),
                const SizedBox(height: 20,),
                MyTextFormField(label: 'Confirmation code',
                    onFocusChange: (value){
                      // perform same functionality
                      textFieldFocus.emailFocus = value;
                    }, borderColor: textFieldFocus.emailFocus,
                    isPassword: false,
                    textInputType: TextInputType.number,
                    textEditingController: _otpTextEditingController),
                const SizedBox(height: 15),
                MyFilledButton(title: 'Next',onPressed: () async{
                  if(await widget.myAuth.verifyOTP(otp: _otpTextEditingController.text )){
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP is verified')));
                    // ignore: use_build_context_synchronously
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SignupMainScreen(email: widget.userEmail),));
                  }
                  else{
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP is not valid')));
                  }
                }),
                const SizedBox(height: 15,),
                MyOutlinedButton(title: 'Sign up with mobile number',onPressed: (){
                  Navigator.pop(context);
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
