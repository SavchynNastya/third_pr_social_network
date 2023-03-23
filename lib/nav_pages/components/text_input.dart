import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool password;
  final String hint;
  final TextInputType textInputType;
  const TextFieldInput({ Key? key, required this.textEditingController,
                        this.password = false, required this.hint, required this.textInputType, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(6),
      ),
      keyboardType: textInputType,
      obscureText: password,
    );
  }
}
