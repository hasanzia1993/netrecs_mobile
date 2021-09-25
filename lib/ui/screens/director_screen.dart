import 'package:flutter/material.dart';

class DirectorScreen extends StatefulWidget {
  DirectorScreen(this.index);
  final int index;

  @override
  _DirectorScreenState createState() => _DirectorScreenState();
}

class _DirectorScreenState extends State<DirectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 34, 34, 1.0),
      body: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.only(left: 15,right: 15.0,top: 50.0),
            child: Column(
                children:[
                  Container(
                      height: 260,
                      child: Row(
                        children: [
                          Expanded(child: Column(
                            children: [
                              Container(height: 240,
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0),
                                      border: Border.all(width: 10.0,color: Colors.white.withOpacity(0.2))
                                  ),
                                  child:  Container(
                                    height: 240,
                                    child: ClipRRect(borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network('https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg',
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
                          SizedBox(width:10),
                          Expanded(
                            child:Container(



                              child: Column(

                                children: [
                                  SizedBox(height: 70),

                                  Text('Akansha Gautam',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontSize: 22.0)),
                                  SizedBox(height: 10,),


                                  Text('Bhilwara, Rajasthan',
                                      textAlign: TextAlign.start,style: TextStyle(color: Colors.white.withOpacity(0.8),
                                          fontSize: 18.0)),
                                  SizedBox(height: 10,),

                                  Text('June 12, 1999',
                                      textAlign: TextAlign.start,style: TextStyle(color: Colors.white.withOpacity(0.8),
                                          fontSize: 18.0)),


                                ],
                              ),
                            ),
                          )

                        ],
                      )
                  ),


                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Biography',
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w600,fontSize: 20.0)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has '
                      'been the industrys standard dummy text ever since the 1500s, when an unknown printer took a'
                      ' galley of type and scrambled it to make a type specimen book.'
                      ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                      ' remaining essentially unchanged. It was popularised in the 1960s with the release of '
                      'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop '
                      'publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white.withOpacity(0.8),
                          fontSize: 16.0)),
                ]
            ),)
      ),
    );
  }
}
