import 'package:flutter/material.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/ui/screens/select_payment_screen.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:nexthour/ui/shared/color_loader.dart';
import 'package:provider/provider.dart';

class SubPlanScreen extends StatefulWidget {
  @override
  _SubPlanScreenState createState() => _SubPlanScreenState();
}

class _SubPlanScreenState extends State<SubPlanScreen> {
//  List used to show all the plans using home API
  List<Widget> _buildCards(int count) {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    List<Widget> cards = List.generate(count, (int index) {
      dynamic planAm = planDetails[index].amount;

      switch (planAm.runtimeType) {
        case int:
          {
            dailyAmount =
                planDetails[index].amount / planDetails[index].intervalCount;
            dailyAmountAp = dailyAmount.toStringAsFixed(2);
          }
          break;
        case String:
          {
            dailyAmount = double.parse(planDetails[index].amount.toString()) /
                double.parse(planDetails[index].intervalCount.toString());
            dailyAmountAp = dailyAmount.toStringAsFixed(2);
          }
          break;
        case double:
          {
            dailyAmount = double.parse(planDetails[index].amount.toString()) /
                double.parse(planDetails[index].intervalCount.toString());
            dailyAmountAp = dailyAmount.toStringAsFixed(2);
          }
          break;
      }
      planDetails[index].status = 1;

//      Used to check soft delete status so that only active plan can be showed
      dynamic mPlanStatus = planDetails[index].status;
      if (mPlanStatus.runtimeType == int) {
        if (planDetails[index].status == 1) {
          return planDetails[index].deleteStatus == 0
              ? SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: subscriptionCards(index, dailyAmountAp),
                );
        } else {
          return SizedBox.shrink();
        }
      } else {
        if ("${planDetails[index].status}" == "1") {
          return "${planDetails[index].deleteStatus}" == "0"
              ? SizedBox.shrink()
              : subscriptionCards(index, dailyAmountAp);
        } else {
          return SizedBox.shrink();
        }
      }
    });
    return cards;
  }

  Widget subscribeButton(index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              height: 40.0,
              width: 150.0,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.amber.withOpacity(0.4),
                    Colors.amber.withOpacity(0.5),
                    Colors.amber.withOpacity(0.6),
                    Colors.amber.withOpacity(0.7),
                  ],
                ),
              ),
              child: new MaterialButton(
                  height: 50.0,
                  splashColor: Color.fromRGBO(72, 163, 198, 0.9),
                  child: Text(
                    "Subscribe",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //   Working after clicking on subscribe button
                    var router = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new SelectPaymentScreen(index));
                    Navigator.of(context).push(router);
                  }),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

//  Amount with currency
  Widget amountCurrencyText(index) {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${planDetails[index].amount}",
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 3.0,
              ),
              Text('${planDetails[index].currency}'),
            ],
          )),
        ]);
  }

//  Daily amount
  Widget dailyAmountIntervalText(dailyAmountAp, index) {
    var dailyAmount = Provider.of<AppConfig>(context, listen: false).planList;
    return Row(children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 100.0),
          child: Text(
            "$dailyAmountAp / ${dailyAmount[index].interval}",
            style: TextStyle(color: Colors.white, fontSize: 8.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);
  }

//  Plan Name
  Widget planNameText(index) {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    return Container(
      height: 35.0,
      color: Color.fromRGBO(20, 20, 20, 1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              '${planDetails[index].name}',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

//  Subscription cards
  Widget subscriptionCards(index, dailyAmountAp) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 5.0,
            child: Column(
              children: <Widget>[
                planNameText(index),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                amountCurrencyText(index),
                dailyAmountIntervalText(dailyAmountAp, index),
              ],
            ),
          ),
          subscribeButton(index),
        ],
      ),
    );
  }

// Scaffold body
  Widget scaffoldBody() {
    var planDetails = Provider.of<AppConfig>(context).planList;

    return planDetails.length == 0
        ? noPlanColumn()
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: planDetails.length == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      noPlanIcon(),
                      SizedBox(
                        height: 25.0,
                      ),
                      noPlanContainer(),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: _buildCards(planDetails.length),
                    ),
                  ));
  }

  //  Empty watchlist container message
  Widget noPlanContainer() {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Text(
        "No subscription plans available.",
        style: TextStyle(height: 1.5, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

//  Empty watchlist icon
  Widget noPlanIcon() {
    return Image.asset(
      "assets/no_plan.png",
      height: 140,
      width: 160,
    );
  }

//  Empty plan column
  Widget noPlanColumn() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          noPlanIcon(),
          SizedBox(
            height: 25.0,
          ),
          noPlanContainer(),
        ],
      ),
    );
  }

//  Build Method
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar:
            customAppBar(context, "Subscription Plans") as PreferredSizeWidget?,
        body: scaffoldBody(),
      ),
    );
  }
}
