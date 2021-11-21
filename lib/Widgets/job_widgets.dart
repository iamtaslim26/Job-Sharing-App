import 'package:flutter/material.dart';
import 'package:linkedin_clone/Jobs/jobs_details.dart';

class JobWidget extends StatefulWidget {

  final String jobTitle,jobDescription,jobId,uploadedBy,userImage,name,email,location,recruitment;

  const JobWidget({Key key,
    this.jobTitle,
    this.jobDescription,
    this.jobId,
    this.uploadedBy,
    this.userImage,
    this.name,
    this.email,
    this.location,
    this.recruitment}) : super(key: key);

  @override
  _JobWidgetState createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepOrange,
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: ListTile(
        onTap: (){
          // Job Details Screen
        },
        onLongPress: (){

        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1)),
          ),
          child: Image.network(widget.userImage),

        ),
        title: Text(widget.jobTitle,maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.name,style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),),

            SizedBox(height: 10,),

            Text(widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),),

          ],
        ),
        trailing: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDetails(
                uploadedBy: widget.uploadedBy,
                jobId: widget.jobId,
              )));
            },
            icon: Icon(Icons.arrow_right_alt_outlined,color: Colors.white,)),
      ),
    );
  }
}
