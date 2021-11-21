import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/DialogBox/error_dialog.dart';
import 'package:linkedin_clone/DialogBox/loading_dialog.dart';
import 'package:linkedin_clone/Jobs/job_screen.dart';
import 'package:linkedin_clone/auth/register_page.dart';
import 'package:linkedin_clone/services/global_variables.dart';

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{

  AnimationController _animationController;
  Animation<double>_animation;

  TextEditingController emailEditingController=TextEditingController();
  TextEditingController passwordEditingController=TextEditingController();

  FocusNode emailFocusNode=FocusNode();
  FocusNode passwordFocusNode=FocusNode();

  final GlobalKey loginKey=GlobalKey<FormState>();

  FirebaseAuth auth=FirebaseAuth.instance;

  bool isObscure=true;
  @override


  @override
  void dispose() {

    _animationController.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();



  }

  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController=AnimationController(vsync: this,duration: Duration(seconds: 20));

    _animation=CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear)..addListener(() {
      setState(() {

      });
    })..addStatusListener((statusListener) {

      if(statusListener==AnimationStatus.completed){
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }


  loginAccount(){

    showDialog(context: context,
        builder: (context){
          return LoadingDialog();
        }
    );

    User currentUser;

    auth.signInWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text)
    .then((value) {

        currentUser=value.user;

        Route newRoute=MaterialPageRoute(builder: (context)=>JobScreen());
        Navigator.pushReplacement(context, newRoute);

    }).catchError((error){

      showDialog(context: context, builder: (context){
        return ErrorDialog(message: "Failed...  "+error.toString(),);
      });
    });

    // if(currentUser!=null){
    //   Route newRoute=MaterialPageRoute(builder: (context)=>JobScreen());
    //   Navigator.pushReplacement(context, newRoute);
    // }


  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
          imageUrl: signUpUrlImage,
           placeholder: (context,url)=>Image.asset("assets/images/wallpaper.jpg",fit: BoxFit.fill,),
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
              padding: const EdgeInsets.symmetric(vertical: 80,horizontal: 16),
              child: ListView(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: loginKey,
                        child: Column(
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height/4,
                                width: size.width/2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/login.png"),
                                    fit: BoxFit.fill
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailEditingController,
                              //focusNode: emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              onEditingComplete: (){
                                FocusScope.of(context).requestFocus(passwordFocusNode);
                              },
                              validator: (value){
                                if(value.isEmpty){
                                  return "This Field is Empty";
                                }

                              },
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white
                              ),

                            ),

                            SizedBox(height: 20,),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: passwordEditingController,

                              //focusNode: passwordFocusNode,
                              style: TextStyle(color: Colors.white),
                              validator: (value){
                                if(value.isEmpty){

                                  return  "The Field is Empty";

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



                            SizedBox(height: 20,),
                            MaterialButton(
                              color: Colors.blue,
                              onPressed: (){
                                // login Code
                                loginAccount();
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
                                    Text("Login",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Forgot Password?",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            SizedBox(height: 40,),

                            Center(
                                child: Row(
                                  children: [
                                    Text("Don't have an account?",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                    SizedBox(width: 10.0,),

                                    InkWell(
                                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage())),
                                      child: Text("SignUp here!",style: TextStyle(
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
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),


    );
  }
}
