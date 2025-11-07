import 'package:tiktok_clone/TikTok/constants.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  // final - Jab Aapko Pata ho ki ye ab change nahi hoga - const But Widgets/Methods Ke Liye
  final TextEditingController controller;
  final IconData myIcon;
  final String myLabelText;
  final bool toHide;
  TextInputField({
    Key? key,
    required this.controller,
    required this.myIcon,
    required this.myLabelText,
    this.toHide = false,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.toHide; // Hide text if it’s a password field
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText:_isObscure,
      controller: widget.controller,
      decoration: InputDecoration(
        icon: Icon(widget.myIcon),
        suffixIcon: widget.toHide
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
        labelText: widget.myLabelText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: borderColor,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
