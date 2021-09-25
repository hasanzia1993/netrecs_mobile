import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:provider/provider.dart';

class MembershipScreen extends StatefulWidget {
  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {

  //  Active plan status row with name
  Widget planStatusRow(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Text("Active Plans : ", style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w400)),
        Text(userDetails.currentSubscription == null ?  userDetails.payment == "Free" ? "Free Trial" : 'N/A' : '${userDetails.currentSubscription}', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w800),),
      ],
    );
  }

//  Plan expiry date row
  Widget planExpiryDateRow(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    var date = userDetails.end.toString();
    String yy = '';
    if(date == null || userDetails.active != "1"){
      yy='N/A';
    }else{
      yy = date.substring(8,10)+"/"+date.substring(5,7)+"/"+date.substring(0,4);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Plan will expired on : ", style: TextStyle(fontSize: 14.0),),
        Text(yy,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w800),) ,
      ],
    );
  }

//  Column that contains rows and status button.
  Widget uiColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        planStatusRow(),
        Padding(padding: EdgeInsets.fromLTRB(15.0, 10.0, 16.0, 0.0)),
        planExpiryDateRow(),
        statusButton(),
      ],
    );
  }

//  Scaffold body containing overall UI of this page
  Widget scaffoldBody(){
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 150.0, 0.0, 20.0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          planStatusRow(),
          Padding(padding: EdgeInsets.fromLTRB(15.0, 10.0, 16.0, 0.0)),
          planExpiryDateRow(),
          statusButton(),
        ],
      ),
    );
  }

//  Status button that handle user active status and stop or resume.
  Widget statusButton(){
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!;
    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 50.0, 16.0, 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Container(
              height: 50.0,
              width: 200.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Color.fromRGBO(72, 163, 198, 0.4).withOpacity(0.4),
                    Color.fromRGBO(72, 163, 198, 0.3).withOpacity(0.5),
                    Color.fromRGBO(72, 163, 198, 0.2).withOpacity(0.6),
                    Color.fromRGBO(72, 163, 198, 0.1).withOpacity(0.7),
                  ],
                ),
              ),

//    This will change the user status after tapping on button and it will also change button
              child: userDetails.active == "1" ? new MaterialButton(
                splashColor: Color.fromRGBO(72, 163, 198, 0.9),
                child: Text(
                  "Stop Subscription",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed:(){
                  _onTap();
                },
              ): userDetails.currentSubscription != null ? new MaterialButton(
                splashColor: Color.fromRGBO(72, 163, 198, 0.9),
                child: Text(
                  "Resume Subscription",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed:(){
                  _onTap();
                },
              ) : new MaterialButton(
                splashColor: Color.fromRGBO(34, 34, 34, 1.0),
                child: Text(
                  "Resume Subscription",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                  Fluttertoast.showToast(msg: "You are not Subscribed.");
                },
              ),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  void _onTap(){
//    if(userPaymentType=='stripe'){
//      stripeUpdateDetails();
//    }else if(userPaymentType=='paypal'){
//      paypalUpdateDetails();
//    }
//    else{
//      return ;
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Membership Plan") as PreferredSizeWidget?,
      body: scaffoldBody(),
    );
  }
}
