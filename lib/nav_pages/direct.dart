import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/dialog.dart';
import 'package:social_network/models/user.dart' as UserStructure;

class Direct extends StatefulWidget {
  // final String currentUsername;
  final List usernames;
  Direct({super.key, required this.usernames});

  @override
  State<Direct> createState() => _DirectState();

}

class _DirectState extends State<Direct>{
  UserStructure.User? user;

  // @override
  // void initState() async{
  //   super.initState();
  //   user = await UserModel().getUserData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Text(user!.username, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.video_call),
                  ),
                  Icon(Icons.add),
                ],
              ),
            ]),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if(details.delta.dx > 0){
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: TextField(    
                textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.white,),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 221, 221, 221),
                    contentPadding: const EdgeInsets.symmetric(vertical: 3),
                  ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Messages', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 20)),
                  Text('Requests',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.blue,
                      fontSize: 18
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.usernames.length,
                itemBuilder: (context, index) {
                  return NewDialog(
                    username: widget.usernames[index],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}