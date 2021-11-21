import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/DialogBox/error_dialog.dart';
import 'package:linkedin_clone/DialogBox/loading_dialog.dart';
import 'package:linkedin_clone/Jobs/job_screen.dart';
import 'package:linkedin_clone/auth/login_page.dart';
import 'package:linkedin_clone/services/global_variables.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterPage extends StatefulWidget {


  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin{

   AnimationController _animationController;
   Animation<double>_animation;

   TextEditingController nameEditingController=TextEditingController();
   TextEditingController passwordEditingController=TextEditingController();
   TextEditingController phoneNumberEditingController=TextEditingController();
   TextEditingController emailEditingController=TextEditingController();
   TextEditingController locationEditingController=TextEditingController();

  FocusNode emailFocusNode=FocusNode();
  FocusNode passwordFocusNode=FocusNode();
  FocusNode nameFocusNode=FocusNode();
  FocusNode positionFocusNode=FocusNode();
  FocusNode phoneNumberFocusNode=FocusNode();

  bool isObscure=true;

  final signUpFormKey=new GlobalKey<FormState>();
  File imageFile;
  FirebaseAuth auth=FirebaseAuth.instance;
  bool isLoading=false;

  String imageUrl="";   // ? is null checker or u can write imageUrl="";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _animationController.dispose();
     emailFocusNode.dispose();
     passwordFocusNode.dispose();
     nameFocusNode.dispose();
     positionFocusNode.dispose();
     phoneNumberFocusNode.dispose();

     nameEditingController.dispose();
     passwordEditingController.dispose();
     phoneNumberEditingController.dispose();
     emailEditingController.dispose();
     locationEditingController.dispose();

  }

   showImageDialog() {

    showDialog(context: context,
        builder:(context){

           return AlertDialog(
             title: Text("Choose an Option",style: TextStyle(fontWeight: FontWeight.bold),),
             content: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[

                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: InkWell(
                       onTap: (){
                         // Open Camera Code

                         getFromCamera();
                       },
                       child: Row(
                         ///mainAxisSize: MainAxisSize.min,
                         children: [
                           Icon(Icons.camera_alt),
                           SizedBox(width: 10,),
                           Text("Camera",style: TextStyle(
                               color: Colors.purple,
                               fontWeight: FontWeight.bold
                           ),),
                         ],
                       )
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: InkWell(
                         onTap: (){
                           // Open Gallery Code
                           getFromGallery();
                         },
                         child: Row(
                           //mainAxisSize: MainAxisSize.min,
                           children: [
                             Icon(Icons.image_sharp),
                             SizedBox(width: 10,),
                             Text("Gallery",style: TextStyle(
                                 color: Colors.purple,
                                 fontWeight: FontWeight.bold
                             ),),
                           ],
                         ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: InkWell(
                         onTap: (){
                           Navigator.pop(context);
                         },
                         child: Row(
                           //mainAxisSize: MainAxisSize.min,
                           children: [
                             Icon(Icons.cancel),
                             SizedBox(width: 10,),
                             Text("Cancel",style: TextStyle(
                                 color: Colors.purple,
                                 fontWeight: FontWeight.bold
                             ),),
                           ],
                         )
                     ),
                   ),
                 ],
               ),
             ),
           );
        }
    );
  }

  void getFromCamera() async{
    PickedFile image=await ImagePicker().getImage(

        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080);

    cropImage(image.path);
    Navigator.pop(context);
  }

  // void cropImage(filePath) async{
  //
  //   File? croppedImage=await ImageCropper.cropImage(
  //       sourcePath: filePath,
  //       maxHeight: 1080,
  //       maxWidth: 1080);
  //
  //   if(croppedImage!=null){
  //
  //     setState(() {
  //         imageFile=croppedImage;
  //     });
  //   }
  //
  // }

  void getFromGallery()async{

    PickedFile image=await ImagePicker().getImage(source:ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    cropImage(image.path);
    Navigator.pop(context);
  }

  void cropImage(filePath)async{

    File cropImage=await ImageCropper.cropImage(sourcePath: filePath,maxHeight: 1080,maxWidth: 1080);

    if(cropImage!=null){
      setState(() {
        imageFile=cropImage;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState

    _animationController=AnimationController(vsync: this,duration: Duration(seconds: 20));
    _animation=CurvedAnimation(parent: _animationController, curve: Curves.linear)..addListener(() {
      setState(() {

      });
    })..addStatusListener((statusListener) {
      if(statusListener==AnimationStatus.completed){

        _animationController.reset();
        _animationController.forward();

      }
    });
    _animationController.forward();
    super.initState();
  }

 uploadImage()async{

    showDialog(context: context,
        builder: (context){

      return LoadingDialog(message:"Loading......");
        }
    );

    String fileName=DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference reference=firebase_storage.FirebaseStorage.instance.ref().child("Users Image").child(fileName+".jpg");
    firebase_storage.UploadTask uploadTask=reference.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((url) {

      imageUrl=url;
      print(imageUrl);

      registerUser();

    });

 }

  registerUser(){
    User currentUser;
    auth.createUserWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text)
        .then((value) {
          
          currentUser=value.user;
          userId=currentUser.uid;
          
          uploadDataToFirebaseDatabase();
          
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>JobScreen()));
          
    }).catchError((error){
      showDialog(context: context,
          builder:(context){
            return ErrorDialog(message: "Error  "+error.toString(),);
          }
      );
    });
  }

   uploadDataToFirebaseDatabase() {

    Map<String,dynamic>userData={
      "userName":nameEditingController.text.trim(),
      "userEmail":emailEditingController.text.trim(),
      "password":passwordEditingController.text.trim(),
      "imageUrl":imageUrl,
      "uid":auth.currentUser.uid,
      "phoneNumber":phoneNumberEditingController.text.trim(),
      "address":locationEditingController.text.trim(),
      "time":DateTime.now(),

    };
    FirebaseFirestore.instance.collection("linkedIn Users").doc(userId).set(userData);
   }




  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CachedNetworkImage(
          imageUrl: signUpUrlImage,
          placeholder: (context,url)=>
            Image.asset("assets/images/wallpaper.jpg",fit: BoxFit.fill,),

            errorWidget: (context,url,error)=>Icon(Icons.error,
          ),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value,0),

         ),

          Container(
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 80),
              child: ListView(
                children: [

                  Form(
                    key: signUpFormKey,
                      child: Column(
                        children:<Widget> [

                          GestureDetector(
                            onTap: (){
                                showImageDialog();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(

                                width: size.width*0.24,
                                height: size.width*0.24,

                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white,width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: imageFile==null? Icon(Icons.camera_alt,color: Colors.blue,size: 30)
                                  :Image.file(imageFile,fit: BoxFit.fill,)  // ! just because it has null checcker
                                ),

                              ),
                            ),
                          ),

                          TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: (){
                                FocusScope.of(context).requestFocus(emailFocusNode);
                              },
                            keyboardType: TextInputType.name,
                            controller: nameEditingController,
                            validator: (value){
                                if(value.isEmpty){
                                  return "This Field is Empty";
                                }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter the Name/Company Name",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder:UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),

                            ),

                          ),
                          SizedBox(height: 15.0,),

                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: (){
                              FocusScope.of(context).requestFocus(passwordFocusNode);
                            },
                            controller: emailEditingController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            validator: (value){
                              if(value.isEmpty ){
                                return "This Field is Empty ";
                              }
                              else if(!value.contains("@")){
                                return "Please Enter the valid Email Address";
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Email Address",
                              hintStyle: TextStyle(color: Colors.white),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),

                          ),
                          SizedBox(height: 15,),

                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: passwordEditingController,
                            onEditingComplete: (){
                              FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                            },
                            focusNode: passwordFocusNode,
                            style: TextStyle(color: Colors.white),
                            validator: (value){
                              if(value.isEmpty){

                                return "The Field is Empty";

                              }
                              else if(value.length<7){
                                return "Password must be more than 7 digits";
                              }
                            },
                            obscureText: isObscure,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {

                                   isObscure=!isObscure ;
                                  });
                                },
                                child: Icon(
                                  isObscure?Icons.visibility_off
                                      :Icons.visibility
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),

                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: (){
                              FocusScope.of(context).requestFocus(positionFocusNode);
                            },
                            focusNode: phoneNumberFocusNode,
                            keyboardType: TextInputType.number,
                            controller: phoneNumberEditingController,
                            validator: (value){
                              if(value.isEmpty){
                                return "This Field is Empty";
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder:UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),

                            ),

                          ),
                          SizedBox(height: 15.0,),

                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: (){
                              FocusScope.of(context).requestFocus(positionFocusNode);
                            },
                            controller: locationEditingController,
                            focusNode: positionFocusNode,
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: Colors.white),
                            validator: (value){
                              if(value.isEmpty ){
                                return "This Field is Empty ";
                              }

                            },
                            decoration: InputDecoration(
                              hintText: "Complete Address",
                              hintStyle: TextStyle(color: Colors.white),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),

                          ),
                          SizedBox(height: 15,),

                          isLoading?Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(),

                            ),
                          ):MaterialButton(
                            color: Colors.blue,
                              onPressed: (){

                              uploadImage();
                              },
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sign Up",style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),

                          Center(
                            child: Row(
                               children: [
                                 Text("Already have an account?",style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 ),
                                 ),
                                 SizedBox(width: 10.0,),

                                 InkWell(
                                   onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage())),
                                   child: Text("Login here",style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 20,
                                     fontWeight: FontWeight.bold,
                                   ),
                                   ),
                                 ),

                               ],
                            )
                          ),



                        ],
                      )
                  )
                ],
              ),
            ),
          )


        ],
      ),
    );
  }








}
