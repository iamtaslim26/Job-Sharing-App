import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/Widgets/bottom_navbar.dart';
import 'package:linkedin_clone/Widgets/job_widgets.dart';
import 'package:linkedin_clone/presisitant/presistant.dart';
import 'package:linkedin_clone/user_state.dart';

class JobScreen extends StatefulWidget {

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  String jobCategoryFilter;
  QuerySnapshot jobs;

  showTaskCategoryDialog(Size size){

    showDialog(context: context,
        builder: (context){
            return AlertDialog(
              backgroundColor: Colors.black12,
              title: Text("Job Category",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              content: Container(
                width: size.width*0.9,
                child: ListView.builder(
                    itemCount: Presistant.taskCategoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            jobCategoryFilter=Presistant.taskCategoryList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_right_alt_outlined,color: Colors.white,),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Presistant.taskCategoryList[index],style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,

                              ),),
                            )
                          ],
                        ),
                      );

                    }),

              ),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Cancel",style: TextStyle(color: Colors.white),),
                ),

                TextButton(
                  onPressed: (){
                    setState(() {
                      jobCategoryFilter=null;
                    });
                  },
                  child: Text("Cancel Filter",style: TextStyle(color: Colors.white),),
                ),
              ],

            );
        }
    );
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      bottomNavigationBar: BottomNavbarForApp(
        indexNum: 0,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.filter_list_outlined, color: Colors.black38,)
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.search, color: Colors.black38,)
          ),
        ],
      ),

      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Jobs")
        .where("recruitment",isEqualTo: true).snapshots(),

        builder: (context,snapshot){
           if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
           else if(snapshot.connectionState==ConnectionState.active){
             if(snapshot.data.docs.isNotEmpty==true){
               return ListView.builder(

                 itemCount: snapshot.data.docs.length,
                   itemBuilder: (context,index){
                   return JobWidget(
                     jobTitle: snapshot.data.docs[index]["jobTitle"],
                     userImage: snapshot.data.docs[index]["userImage"],
                     jobId: snapshot.data.docs[index]["jobId"],
                    // recruitment: snapshot.data.docs[index]["recruitment"],
                     location: snapshot.data.docs[index]["location"],
                     email: snapshot.data.docs[index]["email"],
                     uploadedBy: snapshot.data.docs[index]["uploadedBy"],
                     name: snapshot.data.docs[index]["name"],
                     jobDescription: snapshot.data.docs[index]["jobDescription"],


                   );
                   }
               );
             }
             else{
               Center(child: Text("No jobs available",style: TextStyle(color: Colors.white),),);
             }
           }
           else{
             Center(child: CircularProgressIndicator(),);
           }
        },
      )



    );
  }


}
