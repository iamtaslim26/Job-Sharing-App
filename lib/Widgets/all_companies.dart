import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/Search/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AllCompanies extends StatefulWidget {

 // const AllCompanies({Key? key}) : super(key: key);

  final String userId,userName,userEmail,phoneNumber,userImageUrl;

  const AllCompanies({Key key, this.userId, this.userName, this.userEmail, this.phoneNumber, this.userImageUrl}) : super(key: key);



  @override
  _AllCompaniesState createState() => _AllCompaniesState();
}

class _AllCompaniesState extends State<AllCompanies> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
      child: ListTile(
        onTap: (){
          // Send To Profile Screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileCompanyScreen(

            userID:widget.userId
          )));

        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            )
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(widget.userImageUrl==null?
                  "https://costar.brightspotcdn.com/71/cf/3fda9cc54559af417803fdb67753/gettyimages-1169688104-1.jpg"
                :widget.userImageUrl
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Text("Visit Profile",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: Colors.grey
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.mail_outline),
          onPressed: (){
            _mailTo();
          },
        ),
      ),
    );
  }

  void _mailTo()async {

    var mailUrl="mailto ${widget.userEmail}";
    print("widget.userEmail ${widget.userEmail}");

    if(await canLaunch(mailUrl)){
      await launch(mailUrl);
    }
    else{
      throw "Error Occurred";
    }
  }
}
