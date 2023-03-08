import 'package:flutter/material.dart';

class NewDialog extends StatelessWidget {
  final String username;
  const NewDialog({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color.fromARGB(255, 216, 216, 216), width: 1),
          bottom: BorderSide(color: Color.fromARGB(255, 216, 216, 216), width: 1),
        )
      ),
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 15),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('Sent 2 hours ago',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          const Padding(padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.camera_alt_outlined, color: Color.fromARGB(255, 129, 129, 129),),
          )
        ],
      ),
    );
  }
}
