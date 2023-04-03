// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InstagramCameraButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InstagramCameraButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child:
            Container(
              width: 90,
              height: 90,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                width: 55,
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.purple.shade800, Colors.orange.shade600],
                  ), 
                ),
              ),
        ),
      ),
    );
  }
}
