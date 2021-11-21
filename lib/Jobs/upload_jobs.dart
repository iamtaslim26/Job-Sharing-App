import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/DialogBox/error_dialog.dart';
import 'package:linkedin_clone/DialogBox/loading_dialog.dart';
import 'package:linkedin_clone/Search/profile_screen.dart';
import 'package:linkedin_clone/Widgets/bottom_navbar.dart';
import 'package:linkedin_clone/presisitant/presistant.dart';
import 'package:linkedin_clone/services/global_variables.dart';
import 'package:uuid/uuid.dart';

class UploadJobs extends StatefulWidget {


  @override
  _UploadJobsState createState() => _UploadJobsState();
}

class _UploadJobsState extends State<UploadJobs> {

  TextEditingController taskCategoryController=TextEditingController(text: "Select the Job Type");
  TextEditingController taskTitleController=TextEditingController();
  TextEditingController taskDescriptionController=TextEditingController();
  TextEditingController deadLineController=TextEditingController(text: "Job Deadline date");

  final GlobalKey _formKey=new GlobalKey<FormState>();
  bool isLoading=false;
  DateTime picked;
  Timestamp deadLineTimeStamp;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    taskCategoryController.dispose();
    taskDescriptionController.dispose();
    taskTitleController.dispose();
    deadLineController.dispose();

  }
  

  showCategoryList(Size size){

    showDialog(context: context,
        builder: (context){
          return AlertDialog(
             title: Text("Job Category",
               textAlign: TextAlign.center,
               style: TextStyle(
                 color: Colors.black,
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
               ),
             ),
            backgroundColor: Colors.grey,
            content: Container(
              width: size.width*.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Presistant.taskCategoryList.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        setState(() {

                          taskCategoryController.text=Presistant.taskCategoryList[index];

                        });
                        Navigator.pop(context);


                      },
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                             Icon(Icons.arrow_right_alt_outlined,color: Colors.black,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(Presistant.taskCategoryList[index],
                              style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),

                        ],

                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.canPop(context)?Navigator.pop(context):null;
                },
                  child: Text("cancel",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
            ],
          );
    });
  }

 void  pickedDateDialog()async{

    picked=await showDatePicker(
        context: context,
        initialDate:DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100)
    );

    if(picked!=null){
      setState(() {
        deadLineController.text="${picked.year}-${picked.month}-${picked.day}";
        deadLineTimeStamp=Timestamp.fromMicrosecondsSinceEpoch(picked.microsecondsSinceEpoch);
      });
    }
 }

 void uploadTask(){
    final jobId=Uuid().v4();
    User currentUser=FirebaseAuth.instance.currentUser;
    final uid=currentUser.uid;

    if(deadLineController.text=="Job Deadline Date" && taskCategoryController.text=="Select the Job Type"){
      showDialog(context: context, builder: (context){
        return ErrorDialog(message: "Please fill the column",);
      });
    }

    try{

      showDialog(context: context,
          builder: (context){
            return LoadingDialog();
          }
      );
      Map<String,dynamic>jobDetails={
        "jobId":jobId,
        "uploadedBy":uid,
        "email":currentUser.email,
        "jobTitle":taskTitleController.text,
        "jobDescription":taskDescriptionController.text,
        "jobCategory":taskCategoryController.text,
        "jobDeadLineDate":deadLineTimeStamp,
        "jobComment":[],
        "recruitment":true,
        "createdAt":Timestamp.now(),
        "name":name,
        "userImage":userImage,
        "location":location,
        "applications":0


      };

      FirebaseFirestore.instance.collection("Jobs").doc(jobId).set(jobDetails).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileCompanyScreen()));
      });
    }catch(e){
      showDialog(context: context,
          builder: (context){
            return ErrorDialog(
              message: "Failed....   "+e.toString(),
            );
          }
      );
    }
 }
 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }
  getUserData(){
      
    FirebaseFirestore.instance.collection("linkedIn Users").doc(FirebaseAuth.instance.currentUser.uid).get()
        .then((results) {

          setState(() {
              name=results.data()["userName"];
              userImage=results.data()["imageUrl"];
              location=results.data()["address"];
          });
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black12,
      bottomNavigationBar: BottomNavbarForApp(
        indexNum: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.black12,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Please fill all fields ",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),

                  Divider(thickness: 1,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20.0,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Job Category: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onTap: ()=>showCategoryList(size),
                                controller: taskCategoryController,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Please fill the form";
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.red,width: 1),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),

                            SizedBox(height: 20.0,),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Job Title: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: taskTitleController,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Please fill the form";
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.red,width: 1),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),

                            SizedBox(height: 20.0,),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Job Description:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: taskDescriptionController,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Please fill the form";
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                maxLines: 3,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),

                            SizedBox(height: 20.0,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Job Deadline Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onTap: ()=>pickedDateDialog(),
                                controller: deadLineController,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Please fill the form";
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white,width: 1),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),

                            SizedBox(height: 20,),

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  onPressed: (){
                                      uploadTask();
                                  },
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Text("Post Now",style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),),
                                      SizedBox(width: 5,),
                                      
                                      Icon(Icons.post_add,color: Colors.white,)


                                    ],
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(height: 20.0,),

                          ],
                        ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
