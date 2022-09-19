import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttermessenger/Layout/Home/edit_profile_screen.dart';
import 'package:fluttermessenger/Layout/Home/nav_main.dart';
import 'package:fluttermessenger/Layout/Home/newpost_screen.dart';
import 'package:fluttermessenger/Layout/fixed_mat.dart';
import 'package:fluttermessenger/Layout/registration/login_screen.dart';
import 'package:fluttermessenger/cache/shared_pref.dart';
import 'Cubit/Bloc_Observer.dart';
import 'firebase_options.dart';

void main() async
{

  Bloc.observer = MyBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // for cloud messaging
  //var token = await FirebaseMessaging.instance.getToken();

  await CacheHelper.init();

  UID = await CacheHelper.getValue(key: 'UID')??UID;

  runApp(MyApp());
}

class MyApp extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {

    bool isLogged = UID != '';

    return MaterialApp(
      routes:
      {
        '/editProfileScreen' : (context) => EditProfileScreen(),
        '/newPostScreen' : (context) => NewPostScreen()
      },
      title: 'Flutter Social App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade100,
          elevation: 0.0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20
          )
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        primaryColor: Colors.red,
        accentColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: isLogged ? NavHome() : LoginScreen(),
    );
  }
}
