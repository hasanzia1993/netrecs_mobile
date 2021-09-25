import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/ui/shared/appbar.dart';

class ActorScreen extends StatefulWidget {
  ActorScreen(this.actor);
  final actor;
  @override
  _ActorScreenState createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Actor") as PreferredSizeWidget?,
      body: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.only(left: 15, right: 15.0, top: 15.0, bottom: 15.0),
            child: Column(
                children:[
                  Container(
                      height: 260,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Container(height: 240,
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0),
                                      border: Border.all(width: 10.0,color: Colors.white.withOpacity(0.2))
                                  ),
                                  child:  Container(
                                    height: 240,
                                    child: ClipRRect(borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network('${APIData.actorsImages}${widget.actor.image}',
                                        fit: BoxFit.cover,height: 220,
                                      ),
                                    ),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                                        border: Border.all(width: 8.0,color: Colors.white.withOpacity(0.4))
                                    ),
                                  )
                              )
                            ],
                          )

                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30.0,),
                                  Text('${widget.actor.name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.w500,fontSize: 24.0),
                                  ),
                                  SizedBox(height: 10,),


                                  widget.actor.placeOfBirth == null ? SizedBox.shrink() : Text('${widget.actor.placeOfBirth}',
                                      textAlign: TextAlign.start,style: TextStyle(color: Colors.white.withOpacity(0.9),
                                          fontSize: 16.0)),
                                  SizedBox(height: 10,),
                                  widget.actor.dob == null ? SizedBox.shrink() : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('DOB: ${DateFormat.yMd().format(widget.actor.dob)}',
                                          textAlign: TextAlign.start, style: TextStyle(color: Colors.white.withOpacity(0.9),
                                              fontSize: 16.0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )

                        ],
                      )
                  ),


                  SizedBox(height: 10,),
                  widget.actor.biography == null ? SizedBox.shrink(): Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Biography',
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w600,fontSize: 20.0)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  widget.actor.biography == null ? SizedBox.shrink():  Text('${widget.actor.biography}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white.withOpacity(0.8),
                          fontSize: 16.0)),
                ]
            ),)
      ),
    );
  }
}
