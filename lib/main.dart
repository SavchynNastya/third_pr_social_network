
// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network/cubit/chat_cubit.dart';
import 'package:social_network/cubit/posts_cubit.dart';
import 'package:social_network/cubit/reels_cubit.dart';
// import 'package:social_network/nav_pages/account/account_screen.dart';
import 'package:social_network/providers/user_provider.dart';
import 'package:social_network/nav_pages/auth/login_screen.dart';
import 'package:social_network/providers/story_provider.dart';
import 'package:social_network/providers/story_collection_provider.dart';
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
        BlocProvider(create: (_) => ChatCubit(chatIds: [])),
        BlocProvider(create: (_) => ReelCubit()),
        BlocProvider<PostsCubit>(create: (context) => PostsCubit()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: StoriesProvider()),
        ChangeNotifierProvider.value(value: StoryCollectionProvider()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()..getThemeMode()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            // routes: {
            //   '/feed': (context) => Feed(),
            // },
            // onGenerateRoute: (settings) {
            //   if (settings.name == '/account') {
            //     final String? userId = settings.arguments as String?;
            //     return MaterialPageRoute(
            //       builder: (context) => Account(userId: userId ?? ''),
            //     );
            //   }
            //   return null;
            // },
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
