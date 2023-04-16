import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network/homepage.dart';
import 'package:social_network/nav_pages/auth/components/text_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/pick_image.dart';
import 'package:social_network/authentication/auth.dart';
import 'package:social_network/errors_display/snackbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Uint8List? _image;

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  bool _loading = false;

  addAccountPhoto() async {
    Uint8List image = await pickImage(ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  void signUp() async {
    setState(() {
      _loading = true;
    });

    String response = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!);

    if (response == "success") {
      setState(() {
        _loading = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedInBefore', true);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
              flex: 2,
              child: Container(),
            ),
            Text(
              'Instagram',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 15,
            ),
            Stack(
              children: [
                _image == null
                    ? Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('images/user_photo.jpg'))),
                      )
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(_image!),
                            )),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: addAccountPhoto,
                    icon: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.blue[600],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            TextFieldInput(
              hint: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFieldInput(
              hint: 'Enter your username',
              textInputType: TextInputType.text,
              textEditingController: _usernameController,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFieldInput(
              hint: 'Enter your password',
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: signUp,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: Colors.blue.shade500,
                ),
                child: !_loading
                    ? const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    : const CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Already have an account?"),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Log in",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
    );
  }
}
