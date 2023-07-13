import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/provider/text_field_focused_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/signup_main_screen.dart';
import 'package:instagram_clone/screens/signup_number%20screen.dart';
import 'package:instagram_clone/widgets/my_filled_button.dart';
import 'package:instagram_clone/widgets/my_outlined_button.dart';
import 'package:instagram_clone/widgets/my_text_form_field.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }
  void loginUser() async{
    showDialog(context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),);
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if(res=='success')
      {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
      }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TextFieldFocusProvider>(
      builder: (context, textFieldFocus, child) => Scaffold(
        body: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: 20, top: 80, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                      child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/images/instagram_logo.png'),
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyTextFormField(
                          label: 'email',
                          onFocusChange: (value) {
                            textFieldFocus.emailFocus = value;
                          },
                          borderColor: textFieldFocus.emailFocus,
                          isPassword: false,
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _emailController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextFormField(
                          label: 'email',
                          onFocusChange: (value) {
                            textFieldFocus.passwordFocus = value;
                          },
                          borderColor: textFieldFocus.passwordFocus,
                          isPassword: true,
                          textInputType: TextInputType.text,
                          textEditingController: _passwordController,
                          onPressedPasswordToggle: () {
                            textFieldFocus.setPasswordToggle();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyFilledButton(title: 'Log in',onPressed: loginUser),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Forgot password?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyOutlinedButton(
                            title: 'Create new account',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupMainScreen(),
                                  ));
                            }),
                        const Image(
                          image: AssetImage(
                            'assets/images/meta_logo.png',
                          ),
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
