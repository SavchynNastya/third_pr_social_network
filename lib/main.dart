
// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network/models/posts_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/nav_pages/login.dart';
import 'package:social_network/models/story_model.dart';
import 'package:social_network/models/story_collection_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: PostsModel()),
        BlocProvider<PostsCubit>(create: (context) => PostsCubit()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: StoriesModel()),
        ChangeNotifierProvider.value(value: StoryCollectionModel()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()..getThemeMode()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: Login(),
          );
        }
      )
    );
  }
}
