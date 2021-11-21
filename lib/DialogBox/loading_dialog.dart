import 'package:flutter/material.dart';


class LoadingDialog extends StatelessWidget {

   final String message;

  const LoadingDialog({Key key, this.message}) : super(key: key);


  //const LoadingDialog({required Key key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Center(
            child: CircularProgressIndicator(),
          ),

          SizedBox(height: 10.0,),
          Text("Please wait"),
        ],
      ),
    );
  }
}
