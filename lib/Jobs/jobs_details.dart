import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkedin_clone/Widgets/comments_page.dart';
import 'package:linkedin_clone/services/global_methods.dart';
import 'package:linkedin_clone/services/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class JobDetails extends StatefulWidget {
  final String uploadedBy,jobId;

  const JobDetails({Key key, this.uploadedBy, this.jobId}) : super(key: key);


  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  FirebaseAuth auth=FirebaseAuth.instance;
  TextEditingController commentController=TextEditingController();
  bool isCommenting=false;

  String userImageUrl,jobCategory,jobDescription,authorName,jobTitle;
  bool recruitment;

  Timestamp postedDateTimeStamp,deadLineDateTimeStamp;
  String postedDate,deadlineDate;
  String locationCompany="";
  String emailCompany="";

  int applications=0;
  bool isDeadlineAvailable=false;
  bool showComment=false;

  getJobData()async{

    final DocumentSnapshot userdoc=await FirebaseFirestore.instance.collection("linkedIn Users")
        .doc(widget.uploadedBy).get();

    if(userdoc==null){
      return;
    }
    else{

      setState(() {
        authorName=userdoc.get("userName");
        userImageUrl=userdoc.get("imageUrl");
      });

    }

    final DocumentSnapshot jobDatabase=await FirebaseFirestore.instance.collection("Jobs").doc(widget.jobId).get();

    if(jobDatabase==null){
      return;
    }
    else{
      setState(() {
        jobTitle=jobDatabase.get("jobTitle");
        jobDescription=jobDatabase.get("jobDescription");
        recruitment=jobDatabase.get("recruitment");
        emailCompany=jobDatabase.get("email");
        locationCompany=jobDatabase.get("location");
        applications=jobDatabase.get("applications");
        postedDateTimeStamp=jobDatabase.get("createdAt");
        deadLineDateTimeStamp=jobDatabase.get("jobDeadLineDate");
        //deadlineDate=jobDatabase.get("jobDeadLineDate").toString();

        var postDate=postedDateTimeStamp.toDate();
        postedDate="${postDate.year}-${postDate.month}-${postDate.day}";


      });

      var date=deadLineDateTimeStamp.toDate();
      deadlineDate="${date.year}-${date.month}-${date.day}";
      isDeadlineAvailable=date.isAfter(DateTime.now());
    }



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  applyForJob(){

    final Uri params=Uri(

      scheme: "mailto",
      path: "emailCompany",
      query: "Subject= Apply For $jobTitle & body= Hello, Please attach your Resume/Cv",

    );

    final url=params.toString();
    launch(url);
    addNewApplicant();
  }
  addNewApplicant(){

    var docRef=FirebaseFirestore.instance.collection("Jobs").doc(widget.jobId);
    docRef.update({
      "applications":applications+1
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:Icon(Icons.arrow_back,color: Colors.grey,size: 30,) ,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(jobTitle==null?"Image dal pehele bsdk" :jobTitle,
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold

                      ),),
                    ),
                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.blue
                            ),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                userImageUrl==null?"":userImageUrl
                              )
                            )
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(authorName==null?" ":authorName,

                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold

                                )
                            ),
                            SizedBox(height: 10,),

                            Text(locationCompany==null?" ":locationCompany,

                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,


                                )
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.redAccent,thickness: 2,),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(applications.toString()+" Applications",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,

                            ),

                          ),
                        ),
                        SizedBox(width: 5,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:Icon(Icons.how_to_reg_sharp,color: Colors.white,)

                        ),

                      ],
                    ),

                    FirebaseAuth.instance.currentUser.uid!=widget.uploadedBy?Container()
                        :Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Divider(color: Colors.white,thickness: 2,),
                            SizedBox(height: 10.0,),
                            Text("Recruitment:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height:  10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                TextButton(
                                    onPressed: (){

                                      User currentUser=auth.currentUser;
                                      final uid=currentUser.uid;

                                      if(uid==widget.uploadedBy){
                                        try{
                                          FirebaseFirestore.instance.collection("Jobs")
                                              .doc(widget.jobId)
                                              .update({
                                            "recruitment":true
                                              }
                                            );
                                        }catch(e){
                                          GlobalMethod.showErrorDialog(
                                            ctx: context,
                                            error: "Action can't be performed"
                                          );
                                        }

                                      }
                                      else{
                                        GlobalMethod.showErrorDialog(
                                            ctx: context,
                                            error: "You can't perform this action"
                                        );
                                      }
                                      getJobData();
                                },
                                    child: Text(
                                      "ON",
                                      style: TextStyle(
                                          fontSize:18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),

                                ),


                                Opacity(
                                  opacity: recruitment==true? 1:0,
                                  child: Icon(
                                      Icons.check_box,color: Colors.green,
                                    ),
                                ),

                                SizedBox(width: 40,),

                                TextButton(
                                  onPressed: (){

                                    User currentUser=auth.currentUser;
                                    final uid=currentUser.uid;

                                    if(uid==widget.uploadedBy){
                                      try{
                                        FirebaseFirestore.instance.collection("Jobs")
                                            .doc(widget.jobId)
                                            .update({
                                          "recruitment":false
                                        }
                                        );
                                      }catch(e){
                                        GlobalMethod.showErrorDialog(
                                            ctx: context,
                                            error: "Action can't be performed"
                                        );
                                      }

                                    }
                                    else{
                                      GlobalMethod.showErrorDialog(
                                          ctx: context,
                                          error: "You can't perform this action"
                                      );
                                    }
                                    getJobData();
                                  },
                                  child: Text(
                                    "OFF",
                                    style: TextStyle(
                                      fontSize:18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),

                                ),


                                   Opacity(
                                     opacity:recruitment==false  ?1:0,
                                     child: Icon(
                                      Icons.check_box,
                                      color: Colors.red,
                                  ),
                                   ),


                              ],
                            )
                      ],

                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 3,
                    ),
                    SizedBox(height: 10,),
                    Text("Job Description",
                      style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,

                      ),
                    ),
                    SizedBox(height: 10.0,),

                    Text(jobDescription==null?"":jobDescription,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white,
                        fontSize: 16,

                      ),
                    ),

                  ],

                ),

              ),
            ),


               Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.uploadedBy!=auth.currentUser.uid?Card(
                  color: Colors.white38,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 10,),
                        Center(
                          child: Text(
                            isDeadlineAvailable? "Actively Recruiting, Send CV/Resume"
                                :"DeadLine Passed away",

                            style: TextStyle(
                              color: isDeadlineAvailable?Colors.green
                              :Colors.red,

                              fontStyle:FontStyle.normal ,
                              fontSize: 16,
                              fontWeight: FontWeight.bold

                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Center(
                          child: isDeadlineAvailable? MaterialButton(
                              onPressed: (){
                                applyForJob();
                              },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text("Apply Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                          ):Container(),
                        )
                      ],
                    ),
                  ),
                ):Container(),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white38,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Uploaded on:",style: TextStyle(
                            color: Colors.white,
                          ),),
                          SizedBox(width: 200,),
                          Text(postedDate==null?" ":postedDate,style: TextStyle(
                              color:Colors.white
                          ),)
                        ],
                      ),
                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Deadline date:",style: TextStyle(
                            color: Colors.white,
                          ),),
                          SizedBox(width: 10,),
                          Text(deadlineDate==null?" ":deadlineDate,style: TextStyle(
                              color:Colors.white
                          ),)
                        ],
                      ),
                    ],
                ),
              ),
            ),


            ),

            Padding(
                padding: EdgeInsets.all(4),
              child: Card(
                color: Colors.white38,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                        child: isCommenting?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                                child: TextField(
                                  controller: commentController,
                                  maxLength: 200,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.pink),

                                    )


                                  ),
                                )
                            ),
                            Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: MaterialButton(
                                          onPressed: ()async{
                                            if(commentController.text.length<7){
                                              GlobalMethod.showErrorDialog(
                                                error: "Please write more than 7 letters",
                                                ctx: context
                                              );
                                            }
                                            else{
                                              final generatedId=Uuid().v4();
                                              await FirebaseFirestore.instance.collection("Jobs")
                                              .doc(widget.jobId)
                                              .update({
                                                "jobComment":
                                                    FieldValue.arrayUnion([{

                                                      "userId":auth.currentUser.uid,
                                                      "commentId":generatedId,
                                                      "name":name,
                                                      "imageUrl":userImageUrl,
                                                      "commentBody":commentController.text,
                                                      "time":Timestamp.now(),

                                              }]),
                                              });
                                              Fluttertoast.showToast(msg: "Comment Uploaded Successfully. . .",
                                                timeInSecForIosWeb: 3,
                                                textColor: Colors.white
                                              );
                                              commentController.clear();

                                            }
                                            setState(() {
                                              showComment=true;
                                            });
                                          },
                                        color: Colors.blueAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text("Post",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14
                                          ),
                                        ),
                                      ),
                                    ),
                                      TextButton(
                                          onPressed: (){
                                            
                                            setState(() {
                                              isCommenting=!isCommenting;
                                              showComment=false;
                                            });
                                          }, 
                                          child:Text("Cancel",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14
                                            ), 
                                      )
                                      )],
                                )
                            ),
                          ],
                        ):
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  isCommenting=!isCommenting;
                                });
                              }, 
                              icon: Icon(
                                Icons.add_comment,
                                color: Colors.blueAccent,
                                size: 40,
                              )
                          ),
                          SizedBox(width: 10,),

                          IconButton(
                              onPressed: (){
                                setState(() {
                                    showComment=true;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.blueAccent,
                                size: 40,
                              )
                          ),
                        ],  
                        ),
                      ),
                      showComment==false?Container():
                          Padding(
                              padding:EdgeInsets.all(16),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection("Jobs")
                                .doc(widget.jobId).get(),
                                builder:(context,snapshot){
                                  if(snapshot.connectionState==ConnectionState.waiting){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  else if(snapshot.data==null){
                                    return Center(child: Text("No comments for this job",style: TextStyle(color: Colors.white),),);
                                  }
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data["jobComment"].length,
                                      itemBuilder: (context,index){
                                          return CommentsPage(
                                            commentBody: snapshot.data["jobComment"][index]["commentBody"],
                                            commenterId: snapshot.data["jobComment"][index]["userId"],
                                            commenterImageUrl: snapshot.data["jobComment"][index]["imageUrl"],
                                            commenterName: snapshot.data["jobComment"][index]["name"],
                                            commentId: snapshot.data["jobComment"][index]["commentId"],
                                          );
                                      },
                                      separatorBuilder: (context,index){
                                        return Divider(
                                          color: Colors.white,
                                          thickness: 3,
                                        );
                                      },

                                  );
                                }
                            ),
                          
                          )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
