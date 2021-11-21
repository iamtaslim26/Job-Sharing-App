import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCompanyScreen extends StatefulWidget {

  final String userID;
  const ProfileCompanyScreen({Key key, this.userID}) : super(key: key);

  @override
  _ProfileCompanyScreenState createState() => _ProfileCompanyScreenState();
}

class _ProfileCompanyScreenState extends State<ProfileCompanyScreen> {

   bool isLoading=false;
  String phoneNumber="",email="",name,imageUrl="",joinedAt="";
  bool isSameUser=false;

  getUserData()async{
    isLoading=true;

    DocumentSnapshot userDoc= await FirebaseFirestore.instance.collection("linkedIn Users")
    .doc(widget.userID).get();

    if(userDoc==null){
      return;
    }
    else{

      setState(() {

        email=userDoc.get("userEmail");
        name=userDoc.get("userName");
        phoneNumber=userDoc.get("phoneNumber");
        imageUrl=userDoc.get("imageUrl");
       Timestamp timestampjoinDate=userDoc.get("time");
       var joinedDate=timestampjoinDate.toDate();
       joinedAt="${joinedDate.year}-${joinedDate.month}-${joinedDate.day}";

      });

      User currentUser;
      final uid=currentUser.uid;

      setState(() {
          isSameUser=uid==widget.userID;
      });
    }
  }

   _launchWhatsapp() async {
     var url = "https://wa.me/$phoneNumber?text=Hey buddy, try this super cool new app!";
     if (await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }

   mailTo()async{
    final Uri params=Uri(
      scheme: "mailTo",
      path: email,
      query: "Subject=Write your Subject Please&body=Hello, Please Write Details here",
    );
    final url=params.toString();
    launch(url);
   }

   _launchCaller() async {
     var url = "tel://$phoneNumber";
     if (await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
