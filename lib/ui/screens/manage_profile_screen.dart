

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/seekbar/fluttery_seekbar.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:provider/provider.dart';

var sw='';
var acct;

class ManageProfileScreen extends StatefulWidget {
  @override
  _ManageProfileScreenState createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  DateTime? _date;
  DateTime? currentDate;
  var userPlanStart;
  var userPlanEnd;
  var planDays;
  var progressWidth;
  late var diff;
  var difference;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

//  Pop menu button to edit profile
  Widget _selectPopup(isAdmin) {
    return isAdmin == "1" ?  PopupMenuButton<int>(
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          value: 1,
          child: Text("Change Password"),
        ),
      ],
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (value) {
        if (value == 1) {
          Navigator.pushNamed(context, RoutePaths.changePassword);
        }
      },
      icon: Icon(Icons.more_vert),
    ) : PopupMenuButton<int>(
      color: Theme.of(context).primaryColorLight,
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          value: 1,
          child: Text("Edit Profile"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Change Password"),
        ),
      ],
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (value) {
        if (value == 1) {
          print("value:$value");
          Navigator.pushNamed(context, RoutePaths.updateProfile);
        }
        else if(value ==2){
          Navigator.pushNamed(context, RoutePaths.changePassword);
        }
      },
      icon: Icon(Icons.more_vert),
    );
  }

//  User profile image
  Widget userProfileImage(){
    var userDetails = Provider.of<UserProfileProvider>(context).userProfileModel!;
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Container(
        height: 170.0,
        width: 130.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
        ),
        child: ClipRRect(
          borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
          child: userDetails.user!.image != null ? Image.network(
            "${APIData.profileImageUri}"+"${userDetails.user!.image}",
            scale: 1.7,
            fit: BoxFit.cover,
          ):
          Image.asset(
            "assets/avatar.png",
            scale: 1.7,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

//  Rounded SeekBar
  Widget roundedSeekBar() {
    diff = difference == null ? sw:'$difference'+' Days Remaining';
    return RadialSeekBar(
      trackColor: Color.fromRGBO(20, 20, 20, 1.0),
      trackWidth: 8.0,
      progressColor: difference == null ? Colors.red : Color.fromRGBO(72, 163, 198, 1.0),
      progressWidth: 8.0,
      progress: difference == null ? 1.0 : progressWidth,
      centerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(diff),
          )
        ],
      ),
    );
  }

//  Rounded SeekBar Container
  Widget roundedSeekBarContainer(){
    return Container(
      height: 200.0,
      margin: EdgeInsets.only(top: 450.0, bottom: 15.0),
      padding: EdgeInsets.only(left: 50.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: SizedBox(
              width: 200.0,
              height: 200.0,
              child: roundedSeekBar(),
            ),

          ),
        ],
      ),
    );
  }

//  Pop menu button to edit profile
  Widget popUpMenu(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    var w = MediaQuery.of(context).size.width;
    w = w - 40;
    return Padding(
        padding: EdgeInsets.only(left: w, top: 26.0,),
        child:
        _selectPopup(userDetails.user!.isAdmin)
    );
  }

//  Account status text
  Widget accountStatusText(){
    return new Padding(
      padding: EdgeInsets.only(right: 70.0, top: 60.0),
      child: Text('Account status:', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),),
    );
  }

//  When user is active
  Widget activeStatus(){
    return Padding(
        padding: EdgeInsets.only(right: 70.0),
        child:  Row(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color.fromRGBO(125,183,91, 1.0), width: 1.0)
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: new BoxDecoration(
                      //                    color: Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color.fromRGBO(125,183,91, 1.0), width: 2.5)
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 5.0),
              child:  Text('Active', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),),
            ),
          ],
        )
    );
  }

//  When user is inactive
  Widget inactiveStatus(){
    return Padding(
        padding: EdgeInsets.only(right: 70.0),
        child:  Row(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                //                    color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 1.0)
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 2.5)
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 5.0),
              child:  Text('Inactive', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),),
            ),
          ],
        )
    );
  }

//  When user account status
  Widget userAccountStatus(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            accountStatusText(),
            //    Radial progress bar is used to show the remaining days of user subscription
            userDetails.active == "0" ? inactiveStatus() : activeStatus(),
          ],
        ),
      ],
    );
  }

//  User subscription end date
  Widget subExpiryDate(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            //    This shows subscription end date on manage profile page and also show status of user subscription.
            Container(
              margin: EdgeInsets.only(top: 125.0, right: 40.0),
              child:   Text("${userDetails.end}" == ''? '': 'Subscription will end on', style: TextStyle(color: Colors.white70, fontSize: 12.0,
              ),textAlign: TextAlign.right,),
            ),
            Container(
              margin: EdgeInsets.only(top: 2.0, right: 40.0),
              child:   userDetails.active == "1" ? Text("${userDetails.end}" == ''? sw :'${DateFormat.yMMMd().format(_date!)}',
                style: TextStyle(color: Colors.white, fontSize: 12.0, ),textAlign: TextAlign.right,) :  Text( sw, style: TextStyle(color: Colors.white, fontSize: 12.0, ),textAlign: TextAlign.right,),
            )
          ],
        )
      ],
    );
  }

//  Divider Container
  Widget dividerContainer(){
    return Expanded(
      flex:0,
      child: new Container(
        height: 80.0,
        width: 1.0,
        decoration: new BoxDecoration(
          border: Border(
            right: BorderSide( //                    <--- top side
              color: Colors.white10,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

//  Show mobile number
  Widget mobileNumberText(mobile){
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Mobile Number', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),textAlign: TextAlign.right,),
              SizedBox(height: 5.0,),
              Text(mobile == null ? "" : "", style: TextStyle(color: Colors.white, fontSize: 14.0, ),textAlign: TextAlign.right,)
            ]),
      ),
    );
  }

//  Show date of birth
  Widget dobText(mobile){
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Date of Birth', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),textAlign: TextAlign.right,),
              SizedBox(height: 5.0,),
              Text(mobile == null ? "N/A" : mobile, style: TextStyle(color: Colors.white, fontSize: 14.0, ),textAlign: TextAlign.right,)
            ]),
      ),

    );
  }

//  Date of birth and mobile text container
  Widget dobAndMobile(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;

    return Container(
      height: 80.0,
      margin: EdgeInsets.only(top: 210.0),
      padding: EdgeInsets.only(left: 50.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          dobText(userDetails.user!.dob),
          dividerContainer(),
          mobileNumberText(userDetails.user!.mobile),
        ],
      ),
    );
  }

//  Show joined date text
  Widget joinedDateText(createdAt){
    var sd = DateFormat("dd-mm-y HH:MM").format(createdAt);
    var split = "$sd".split(' ').map((i) {
      if (i == "") {
        return Divider();
      } else {
        return Text(i,style: TextStyle(color: Colors.white70, fontSize: 14.0, ),textAlign: TextAlign.left,);
      }
    }).toList();

    return Expanded(
      flex:1,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Joined on", style: TextStyle(color: Colors.white, fontSize: 24.0),textAlign: TextAlign.left,),
              SizedBox(height: 5.0,),
              split[0],
              SizedBox(height: 3.0,),
              split[1]
            ]),
      ),

    );
  }

//  Show name and joined date container
  Widget nameAndJoinedDateContainer(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(top: 322.0),
      padding: EdgeInsets.only(left: 50.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(userDetails.user!.name!, style: TextStyle(color: Colors.white, fontSize: 24.0),textAlign: TextAlign.left,),
                    SizedBox(height: 5.0,),
                    Flexible(child: Text(userDetails.user!.email!, style: TextStyle(color: Colors.white70, fontSize: 14.0, ),textAlign: TextAlign.left,),),
                  ]),
            ),
          ),
          joinedDateText(userDetails.user!.createdAt),
        ],
      ),
    );
  }

//  Container used as border
  Widget borderContainer1(){
    return Container(
      margin: EdgeInsets.only(left: 50.0),
      height: 210.0,
      decoration: new BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
            width: 2.0,
          ),
        ),
      ),
    );
  }

//  Container used as border
  Widget borderContainer2(){
    return Container(
      margin: EdgeInsets.only(left: 50.0),
      height: 292.0,
      decoration: new BoxDecoration(
        border: Border(
          bottom: BorderSide( //                    <--- top side
            color: Colors.white10,
            width: 2.0,
          ),
        ),
      ),
    );
  }

//  Overall UI of this page is in stack
  Widget stack() {
    return Stack(
      children: <Widget>[
        userProfileImage(),
        userAccountStatus(),
        subExpiryDate(),
        borderContainer1(),
        dobAndMobile(),
        borderContainer2(),
        nameAndJoinedDateContainer(),
        roundedSeekBarContainer(),
        popUpMenu(),
      ],
    );
  }

//  Scaffold body
  Widget scaffoldBody(){
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            userProfileImage(),
            userAccountStatus(),
            subExpiryDate(),
            borderContainer1(),
            dobAndMobile(),
            borderContainer2(),
            nameAndJoinedDateContainer(),
            roundedSeekBarContainer(),
            popUpMenu(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    if("${userDetails.end}" == '' || "${userDetails.end}" == 'N/A' || "${userDetails.end}" == null|| "${userDetails.active}" == "0"){
      sw = 'You are not Subscribed';
      setState(() {
        difference = null;
      });
    }else{
      setState(() {
        _date = userDetails.end;
      });
      difference = "${userDetails.active}" == "1" ? _date!.difference(userDetails.currentDate!).inDays: 0.0;
      planDays = userDetails.end!.difference(userDetails.start!).inDays;
      print(difference/planDays);
      progressWidth = difference/planDays;
    }
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "Manage Profile") as PreferredSizeWidget?,
        body: scaffoldBody(),
      ),);
  }
}
