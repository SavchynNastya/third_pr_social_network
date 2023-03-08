import 'package:flutter/material.dart';

class AddPhoto extends StatelessWidget {
  const AddPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 500,
          color: Colors.grey[300],
        ),
        const Align(
          alignment: Alignment.center,
          child: Padding(padding: EdgeInsets.only(top: 15),
            child: Icon(Icons.camera_outlined, size: 50,),
          )
        )
      ],
    );
  }
}