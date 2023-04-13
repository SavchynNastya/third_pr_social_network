
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_network/errors_display/snackbar.dart';
import 'package:social_network/models/story.dart';
import 'package:social_network/providers/story_provider.dart';
import 'package:social_network/providers/story_collection_provider.dart';
import 'package:social_network/models/story_collection.dart';

class StoryOpen extends StatefulWidget {
  final Story story;
  const StoryOpen({super.key, required this.story});

  @override
  State<StoryOpen> createState() => _StoryOpenState();

}

class _StoryOpenState extends State<StoryOpen>{

  final collectionNameController = TextEditingController();

  void addCollection(String uid, String storyId) async {
    try {
      String res = await StoryCollectionProvider().createStoryCollection(
        uid, collectionNameController.text, storyId);
      if (res == "success") {
        showSnackBar(
          context,
          'Created!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void addStoryToCollection(String collectionId, String storyId) async {
    try {
      String res = await StoryCollectionProvider()
          .addStoryToCollection(collectionId, storyId);
      if (res == "success") {
        showSnackBar(
          context,
          'Added!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void removeFromCollection(String collectionId, String storyId) async {
    try {
      String res = await StoryCollectionProvider()
          .removeFromCollection(collectionId, storyId);
      if (res == "success") {
        showSnackBar(
          context,
          'Removed!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void showCollections(BuildContext parentContext) async{
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose a collection'),
          children: <Widget>[
            Row(
              children: [
                StreamBuilder<List<StoryCollection>>(
                  stream: StoryCollectionProvider().fetchCollections(FirebaseAuth.instance.currentUser!.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<StoryCollection>> snapshot) {
                        // print(snapshot);
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('Loading...');
                    } else {
                      List<StoryCollection> collections = snapshot.data!;
                      return Column(
                        children: collections
                            .map((collection) => TextButton(
                                onPressed: () {
                                  addStoryToCollection(collection.storyCollectionId, widget.story.storyId);
                                  Navigator.pop(context);
                                },
                                child: Text(collection.storyCollectionName),
                              )
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void createCollection(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Collection'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                autofocus: false,
                controller: collectionNameController,
                textAlign: TextAlign.start,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Create"),
                  onPressed: () {
                    addCollection(
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.story.storyId
                    );
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  void deleteStory(String storyId) async {
    try {
      String res = await StoriesProvider().deleteStory(storyId);
      if (res == "success") {
        showSnackBar(
          context,
          'Story has been successfully deleted.',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.story.storyPic),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 35,
          left: 8,
          right: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.story.profilePic)
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      widget.story.username,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
              widget.story.uid == FirebaseAuth.instance.currentUser!.uid ?
              Row(
                children: [
                  IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Delete a story?'),
                        children: <Widget>[
                          SimpleDialogOption(
                              padding: const EdgeInsets.all(20),
                              child: const Text('Yes'),
                              onPressed: () async {
                                Navigator.pop(context);
                                deleteStory(widget.story.storyId);
                              }),
                          SimpleDialogOption(
                            padding: const EdgeInsets.all(20),
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.disabled_by_default_outlined, color: Colors.white),
              ) ,
              
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Add to collection'),
                        children: <Widget>[
                          SimpleDialogOption(
                              padding: const EdgeInsets.all(20),
                              child: const Text('Create new'),
                              onPressed: () {
                                Navigator.pop(context);
                                createCollection(context);
                                
                              },
                          ),
                          SimpleDialogOption(
                            padding: const EdgeInsets.all(20),
                            child: const Text("Show collections"),
                            onPressed: () {
                              Navigator.pop(context);
                              showCollections(context);
                            },
                          ),
                          SimpleDialogOption(
                            padding: const EdgeInsets.all(20),
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              ) ,
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Delete from collection'),
                        children: <Widget>[
                          StreamBuilder<List<StoryCollection>>(
                            stream: StoryCollectionProvider().fetchCollectionsWhereStoryPresent(FirebaseAuth.instance.currentUser!.uid, widget.story.storyId),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<StoryCollection>> snapshot) {
                                  // print(snapshot);
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return const Text('Loading...');
                              } else {
                                List<StoryCollection> collections = snapshot.data!;
                                return Column(
                                  children: collections
                                      .map((collection) => TextButton(
                                          onPressed: () {
                                            removeFromCollection(collection.storyCollectionId, widget.story.storyId);
                                            Navigator.pop(context);
                                          },
                                          child: Text(collection.storyCollectionName),
                                        )
                                      )
                                      .toList(),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.folder_delete_outlined, color: Colors.white),
              ) ,
                ],
              ) :
              const SizedBox(),
            ],
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
              child:  Row(
                children: [
                  SizedBox(
                    width: 295,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 221, 221, 221),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.favorite_border_rounded, color: Colors.white,)
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.send_outlined, color: Colors.white,)
                      ),
                    ],
                  )
                ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}