import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/Jobs/job_screen.dart';
import 'package:linkedin_clone/Jobs/upload_jobs.dart';
import 'package:linkedin_clone/auth/register_page.dart';
import 'package:linkedin_clone/user_state.dart';

import 'auth/login_page.dart';

void main() {
WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp>_initializing=Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializing,
        builder: (context,snapshot){

          if(snapshot.connectionState==ConnectionState.waiting){

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text("Please Wait .... we are connecting"),
                  ),
                ),
              ),
            );
          }
          else if(snapshot.hasError){

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LinkedIn Clone',

              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text("Something Error.. "),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            title: 'LinkedIn Clone',
            theme: ThemeData(

              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.black
            ),
            //home:FirebaseAuth.instance.currentUser!=null?JobScreen():RegisterPage(),
            home: UploadJobs(),

          );
        }
    );

  }
}


