// ignore_for_file: sort_child_properties_last, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:social_network/authentication/auth.dart';
import 'package:social_network/homepage.dart';
import 'package:social_network/nav_pages/sign_up.dart';
import 'package:social_network/nav_pages/components/text_input.dart';
import 'package:social_network/errors_display/snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20), minimumSize: Size(double.infinity, 40));

  bool _loading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logIn() async {
    setState(() {
      _loading = true;
    });
    String response = await AuthMethods().loginUser(
      email: _emailController.text, 
      password: _passwordController.text,
    );

    if(response == "success"){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false);

      setState(() {
        _loading = false;
      });

    } else {
      setState(() {
        _loading = false;
      });
      showSnackBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          const Text(
            'Instagram',
            style: TextStyle(
                color: Colors.black, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          TextFieldInput(
            hint: 'Enter your email',
            textInputType: TextInputType.text,
            textEditingController: _emailController,
          ),
          const SizedBox(
            height: 25,
          ),
          TextFieldInput(
            hint: 'Enter your password',
            textInputType: TextInputType.text,
            textEditingController: _passwordController,
            // password: true,
          ),
          const SizedBox(
            height: 25,
          ),
          InkWell(
            child: Container(
              child: !_loading
                  ? const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                      fontSize: 18),
                    )
                  : CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                color: Colors.blue.shade500,
              ),
            ),
            onTap: logIn,
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text("Don't have an account?"),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignUp(),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    )));
  }
}
