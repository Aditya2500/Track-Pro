import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final FocusNode focusNode;
  final Function onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextEditingController controller;

  InputFieldArea({
    this.hint,
    this.obscure,
    this.icon,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return (
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.black,
            ),
          ),
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textCapitalization: TextCapitalization.none,
          obscureText: obscure,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 14.0
          ),
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Colors.black,
            ),
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 14.0
            ),
            contentPadding: EdgeInsets.only(
              top: 20.0,
              right: 20.0,
              bottom: 20.0,
              left: 5.0
            ),
          ),
        ),
      )
    );
  }
}