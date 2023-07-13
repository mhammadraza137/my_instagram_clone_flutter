import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/signup_email_otp_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:email_otp/email_otp.dart';
import '../provider/text_field_focused_provider.dart';
import '../widgets/my_filled_button.dart';
import '../widgets/my_outlined_button.dart';
import '../widgets/my_text_form_field.dart';

class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({Key? key}) : super(key: key);

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  final EmailOTP myEmailAuth = EmailOTP();
  final TextEditingController _emailTextEditingController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _emailTextEditingController.dispose();
  }
  void sentOtpToEmail() async{
    showDialog(context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: blueColor,
        ),
      ),);
    myEmailAuth.setConfig(
        appEmail: 'instaclone@mail.com',
        appName: 'Insta Clone',
        userEmail: _emailTextEditingController.text,
        otpLength: 6,
        otpType: OTPType.digitsOnly
    );
    if(await myEmailAuth.sendOTP() == true){
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupEmailOTPScreen(userEmail: _emailTextEditingController.text,myAuth: myEmailAuth),));
    }
    else {
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Otp sent failed')));
    }
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
                Text('What\'s your email?',
                  style: GoogleFonts.poppins(fontSize: 23,fontWeight: FontWeight.w500,letterSpacing: -1),
                ),
                Text('Enter the email where you can be contacted. No one will see this on your profile.',
                  style: GoogleFonts.poppins(fontSize: 16 , letterSpacing: -1,color: Colors.black54),
                ),
                const SizedBox(height: 20,),
                MyTextFormField(label: 'Email',
                    onFocusChange: (value){
                      // perform same functionality
                      textFieldFocus.emailFocus = value;
                    }, borderColor: textFieldFocus.emailFocus,
                    isPassword: false,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailTextEditingController),
                const SizedBox(height: 15),
                MyFilledButton(title: 'Next',onPressed: (){
                  sentOtpToEmail();
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
