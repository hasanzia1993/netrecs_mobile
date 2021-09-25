import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexthour/models/user_profile_model.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:nexthour/ui/shared/blank_history.dart';
import 'package:nexthour/ui/shared/seperator2.dart';
import 'package:provider/provider.dart';

class OtherHistoryScreen extends StatefulWidget {
  @override
  _OtherHistoryScreenState createState() => _OtherHistoryScreenState();
}

class _OtherHistoryScreenState extends State<OtherHistoryScreen> {
  late List<Paypal> itemList;

  @override
  void initState() {
    super.initState();
    this._historyList();
  }

//  Subscription start date and end date
  Widget subscriptionFromTo(planDetails){
    print("SS: ${planDetails.subscriptionTo == null}");
    return Container(
      child: planDetails.subscriptionTo == null ? Text('') : Text(
        'From' +
            ' ' +
            DateFormat("d-m-y HH:MM").format(planDetails.subscriptionFrom) +
            ' ' +
            'To' +
            '\n' +
            DateFormat("d-m-y HH:MM").format(planDetails.subscriptionTo),
        style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            letterSpacing: 0.8,
            height: 1.3,
            fontWeight: FontWeight.w500),
      ),
    );
  }

//    Payment amount
  Widget amount(planDetails) {
    return planDetails.plan ==  null ?  Container(
      child: Text(
        'Free',
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600),
      ),
    ): Container(
      child: planDetails.plan.currency != null ? Text(
        "${planDetails.price}" +' '+ "${planDetails.plan.currency}",
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600),
      ) : Text(
        planDetails.price.toString() +' '+ "${planDetails.plan.currency}",
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600),
      ),
    );
  }

//   Payment created date
  Widget createdDate(planDetails){
    return Expanded(
      flex: 2,
      child: Text(
        "${planDetails.createdAt}" + ' via ' + '\n' + "${planDetails.method}",
        style:
        TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }

//    Row transaction id
  Widget transactionId(planDetails){
    return Expanded(
      child: Text(
        'Transaction ID:' + '\n' + planDetails.paymentId,
        style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            height: 1.3),
      ),
    );
  }

//    Row plan name
  Widget planNameRow(planDetails){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0),
        ),
        Expanded(
            child: planDetails.plan == null ? Text('Free Trial',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ): Text(planDetails.plan.name.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            )
        ),
      ],
    );
  }

//    Row separator
  Widget rowSeparator(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
          child: Separator2(),
        ),
      ],
    );
  }

//    Row created date
  Widget rowCreatedDate(planDetails){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          createdDate(planDetails),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                amount(planDetails),
                SizedBox(
                  height: 3.0,
                ),
                subscriptionFromTo(planDetails),
              ],
            ),
          ),
        ],
      ),
    );
  }

//    Row transaction id
  Widget rowTransactionId(i){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          transactionId(i),
        ],
      ),
    );
  }

//   Cards that display history
  Widget historyCard(planDetails){
    return Card(
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16.0 / 6.5,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                ),
                planNameRow(planDetails),
                rowSeparator(),
                rowCreatedDate(planDetails),
                rowTransactionId(planDetails),
              ],
            ),
          ),
        ],
      ),
    );
  }

//  Scaffold body content
  Widget scaffoldBody(paypalHistory){
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:  SingleChildScrollView(
          child: paypalHistory.length == 0 ? BlankHistoryContainer() : Column(
            children: _buildCards(itemList.length)! ,
          ),
        )
    );
  }

//  Build method
  @override
  Widget build(BuildContext context) {
    itemList = _historyList();
    var paypalHistory = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!.paypal!;
    return SafeArea(
      child: paypalHistory.length == 0 ? BlankHistoryContainer()
          : Scaffold(
        appBar: customAppBar(context, "Other Payment History") as PreferredSizeWidget?,
        body: scaffoldBody(paypalHistory),
      ),
    );
  }

//  Cards that shows history
  List <Card>? _buildCards(int count) {
    var paypalHistory = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!.paypal!;
    for(var i=0; i<paypalHistory.length; i++){
      List<Card> cards = List.generate(
        count,
            (i) => historyCard(paypalHistory[i]) as Card,
      );
      return cards;
    }
    return null;
  }

//  List of payment history excepting stripe payment
  List<Paypal> _historyList() {
    var paypalHistory = Provider.of<UserProfileProvider>(context, listen: false).userProfileModel!.paypal!;
    return List<Paypal>.generate(paypalHistory.length, (int index){
      return Paypal(
        id: paypalHistory[index].id,
        userId: paypalHistory[index].userId,
        paymentId: paypalHistory[index].paymentId,
        userName: paypalHistory[index].userName,
        packageId: paypalHistory[index].packageId,
        price: paypalHistory[index].price,
        status: paypalHistory[index].status,
        method: paypalHistory[index].method,
        subscriptionFrom: paypalHistory[index].subscriptionFrom,
        subscriptionTo: paypalHistory[index].subscriptionTo,
        createdAt: paypalHistory[index].createdAt,
        updatedAt: paypalHistory[index].updatedAt,
        plan: paypalHistory[index].plan,
      );
    });
  }
}









