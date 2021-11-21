import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkedin_clone/Jobs/job_screen.dart';
import 'package:linkedin_clone/Jobs/upload_jobs.dart';
import 'package:linkedin_clone/auth/login_page.dart';

class UserState extends StatefulWidget {


  @override
  _UserStateState createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(

        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){

          if(snapshot.data==null){
            print("User is not Logged in yet");
            return LoginPage();

          }
          else if(snapshot.hasData){

            return UploadJobs();
          }
          else if(snapshot.hasError){

            return Scaffold(
              body: Center(
                child: Text("Something Error"),
              ),
            );
          }
          else if(snapshot.connectionState==ConnectionState.waiting){

            return Center(
              child: CircularProgressIndicator(),
            );
          }

          else{
            return Scaffold(
              body: Center(
                child: Text("Something Error"),
            ),
            );
          }
        }
    );
  }
}
