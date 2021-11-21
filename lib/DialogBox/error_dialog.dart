import 'package:flutter/material.dart';
import 'package:linkedin_clone/user_state.dart';


class ErrorDialog extends StatelessWidget {

  final String message;

  const ErrorDialog({Key key, this.message}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      key: key,
      content: Text(message),
      actions: <Widget>[

        ElevatedButton(

          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UserState())),

            child: Center(
              child: Text("OK"),
    )
    ),
      ],

    );
  }
}
