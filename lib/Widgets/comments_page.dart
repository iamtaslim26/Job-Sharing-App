import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/Search/profile_screen.dart';

class CommentsPage extends StatefulWidget {
final String  commentId,commenterId,commenterName,commentBody,commenterImageUrl;

  const CommentsPage({Key key, this.commentId, this.commenterId, this.commenterName, this.commentBody, this.commenterImageUrl}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {

  List<Color>_colors=[
    Colors.amber,
    Colors.orange,
    Colors.pink.shade700,
    Colors.brown,
    Colors.cyan,
    Colors.blue,
    Colors.deepOrange
  ];
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(

      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileCompanyScreen(userID: widget.commenterId,))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Flexible(
            flex: 1,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(

                  border: Border.all(color: _colors[1],width: 2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.commenterImageUrl),
                    fit: BoxFit.cover
                  )

                ),
              )
          ),
          SizedBox(width: 6,),
          Flexible(
            flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.commenterName,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.normal
                  ),),

                  Text(widget.commentBody,
                    maxLines: 5,

                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                  ),)
                ],
              )
          ),
        ],
      ),
    );
  }
}
