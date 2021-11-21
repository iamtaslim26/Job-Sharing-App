import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/Jobs/job_screen.dart';
import 'package:linkedin_clone/Jobs/upload_jobs.dart';
import 'package:linkedin_clone/Search/profile_screen.dart';
import 'package:linkedin_clone/Search/search_companies.dart';
import 'package:linkedin_clone/user_state.dart';

class BottomNavbarForApp extends StatelessWidget {

  int indexNum=0;
  BottomNavbarForApp({this.indexNum});

  void logout(context){

    FirebaseAuth auth=FirebaseAuth.instance;

    showDialog(context: context,
        builder: (context){

            return AlertDialog(

              backgroundColor: Colors.black,
              title: Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.logout,size: 36,color: Colors.white70,),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Logout",style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),

                ],

              ),
              content: Text("Do you want to Logout?",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey
                ),
              ),

              actions: [
                ElevatedButton(
                onPressed: (){
                  auth.signOut().then((value) {
                    Navigator.canPop(context)?Navigator.pop(context):null;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserState()));
                  });
                },
                  child: Text("Yes"),
               ),

                ElevatedButton(
                  onPressed: (){
                    Navigator.canPop(context)?Navigator.pop(context):null;
                  },
                  child: Text("No"),
                ),
              ],

            );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return CurvedNavigationBar(
        color: Colors.white,
        height: 53,
        index: indexNum,
        backgroundColor: Colors.black,
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(
          milliseconds: 3000,
        ),
        buttonBackgroundColor: Colors.white,

        items:<Widget> [

          Icon(Icons.list,size: 18,color: Colors.blue,),
          Icon(Icons.search,size: 18,color: Colors.blue,),
          Icon(Icons.add,size: 18,color: Colors.blue,),
          Icon(Icons.person_pin,size: 18,color: Colors.blue,),
          Icon(Icons.exit_to_app,size: 18,color: Colors.blue,),
        ],

      onTap: (index){
          if(index==0){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>JobScreen()));
          }
          else if(index==1){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SearchCompanies()));
          }
          else if(index==2){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadJobs()));
          }
          else if(index==3){

              FirebaseAuth auth=FirebaseAuth.instance;
              final User user=auth.currentUser;   // ? null checker
              final String uid=user.uid;

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileCompanyScreen(userID: uid)));
                          
            }
          else if(index==4){
            // write code for logout
            logout(context);
          }
      }

    );
  }
}
