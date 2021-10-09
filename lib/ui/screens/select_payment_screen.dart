//import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter_swipable/flutter_swipable.dart';
//import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nexthour/common/apipath.dart';
import 'dart:async';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/providers/payment_key_provider.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/gateways/bank_payment.dart';
import 'package:nexthour/ui/gateways/braintree_payment.dart';
import 'package:nexthour/ui/gateways/in_app_payment.dart';
import 'package:nexthour/ui/gateways/paypal/PaypalPayment.dart';
import 'package:nexthour/ui/gateways/paystack_payment.dart';
import 'package:nexthour/ui/gateways/paytm_payment.dart';
import 'package:nexthour/ui/gateways/razor_payment.dart';
import 'package:nexthour/ui/gateways/stripe-test.dart';
import 'package:nexthour/ui/gateways/stripe_payment.dart';
import 'package:nexthour/ui/screens/apply_coupon_screen.dart';
import 'package:provider/provider.dart';
//import 'package:swipedetector/swipedetector.dart';

List listPaymentGateways = [];
String couponMSG = '';
var validCoupon, percentOFF;
bool isCouponApplied = true;
var mFlag = 0;
String couponCode = '';
var genCoupon;

class SelectPaymentScreen extends StatefulWidget {
  SelectPaymentScreen(this.planIndex);

  final planIndex;

  @override
  _SelectPaymentScreenState createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen>
    with TickerProviderStateMixin, RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController? _scrollViewController;

  TabController? _paymentTabController;
//  var dailyAmount;
//  int? initialDragTimeStamp;
//  int? currentDragTimeStamp;
//  int? timeDelta;
//  double? initialPositionY;
//  double? currentPositionY;
//  double? positionYDelta;
//  bool _validate = false;
  bool isDataAvailable = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  bool loading = true;
//  String _swipeDirection = "";
//  var controllers = CardController();
//  StreamController<double> _controller = StreamController<double>();

  PageController hPagerController = PageController(keepPage: true);
  PageController vPagerController = PageController(keepPage: true);
  double mWidth = 100.0;
  double mHeight = 100.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    isCouponApplied = true;
    mFlag = 0;
    validCoupon = false;
    couponCode = '';
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      PaymentKeyProvider paymentKeyProvider =
          Provider.of<PaymentKeyProvider>(context, listen: false);
      await paymentKeyProvider.fetchPaymentKeys();
      listPaymentGateways = [];
      var stripePayment = Provider.of<AppConfig>(context, listen: false)
          .appModel!
          .config!
          .stripePayment;
      var btreePayment = Provider.of<AppConfig>(context, listen: false)
          .appModel!
          .config!
          .braintree;
      var paystackPayment = Provider.of<AppConfig>(context, listen: false)
          .appModel!
          .config!
          .paystack;
      var bankPayment = Provider.of<AppConfig>(context, listen: false)
          .appModel!
          .config!
          .bankdetails;
      var razorPayPaymentStatus = Provider.of<AppConfig>(context, listen: false)
          .appModel!
          .config!
          .razorpayPayment;
      var paytmPaymentStatus = Provider.of<AppConfig>(context, listen: false)
          .appModel!
          .config!
          .paytmPayment;
      var payPal = Provider.of<AppConfig>(context, listen: false)
          .appModel!
          .config!
          .paypalPayment;
//      var productMap;
      listPaymentGateways.add(
//       productMap = {
//        'title': 'inapp',
//        'status': 1,
//      }
          PaymentGateInfo(title: 'inapp', status: 1));
      if (stripePayment == 1 || "$stripePayment" == "1") {
        listPaymentGateways.add(PaymentGateInfo(title: 'stripe', status: 1)
//        productMap = {
//        'title': 'stripe',
//        'status': 1,
//        }
            );
      }
      if (btreePayment == 1 || "$btreePayment" == "1") {
        listPaymentGateways.add(PaymentGateInfo(title: 'btree', status: 1)
//          productMap = {
//          'title': 'btree',
//          'status': 1,
//          }
            );
      }
      if (paystackPayment == 1 || "$paystackPayment" == "1") {
        listPaymentGateways.add(
//          productMap = {
//            'title': 'paystack',
//            'status': 1,
//          }
            PaymentGateInfo(title: 'paystack', status: 1));
      }
      if (bankPayment == 1 || "$bankPayment" == "1") {
        listPaymentGateways.add(
//          productMap = {
//            'title': 'bankPayment',
//            'status': 1,
//          }
            PaymentGateInfo(title: 'bankPayment', status: 1));
      }
      if (razorPayPaymentStatus == 1 || "$razorPayPaymentStatus" == "1") {
        listPaymentGateways.add(
//          productMap = {
//            'title': 'razorPayment',
//            'status': 1,
//          }
            PaymentGateInfo(title: 'razorPayment', status: 1));
      }
      if (paytmPaymentStatus == 1 || "$paytmPaymentStatus" == "1") {
        listPaymentGateways.add(
//         productMap = {
//            'title': 'paytmPayment',
//            'status': 1,
//          }
            PaymentGateInfo(title: 'paytmPayment', status: 1));
      }
      if (payPal == 1 || "$payPal" == "1") {
        listPaymentGateways.add(
//          productMap = {
//            'title': 'paypalPayment',
//            'status': 1,
//          }
            PaymentGateInfo(title: 'paypalPayment', status: 1));
      }
      setState(() {
        loading = false;
      });
      _paymentTabController = TabController(
          vsync: this,
          length: listPaymentGateways != null ? listPaymentGateways.length : 0,
          initialIndex: 0);
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
  }

//  Apply coupon forward icon
  Widget applyCouponIcon() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(left: 0.0),
        child: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white70,
        ),
      ),
    );
  }

//  Gift icon
  Widget giftIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Icon(
        Icons.card_giftcard,
        color: Color.fromRGBO(125, 183, 91, 1.0),
      ),
    );
  }

//  Payment method tas
  Widget paymentMethodTabs() {
    return PreferredSize(
      child: SliverAppBar(
        title: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _paymentTabController,
          indicatorColor: activeDotColor,
          isScrollable: true,
          tabs: List<Tab?>.generate(
            listPaymentGateways == null ? 0 : listPaymentGateways.length,
            (int index) {
              if (listPaymentGateways[index].title == 'stripe') {
                return Tab(
                  child: tabLabelText('Credit Card'),
                );
              }
              if (listPaymentGateways[index].title == 'btree') {
                return Tab(
                  child: tabLabelText('Braintree'),
                );
              }

              if (listPaymentGateways[index].title == 'paystack') {
                return Tab(
                  child: tabLabelText('Paystack'),
                );
              }
              if (listPaymentGateways[index].title == 'bankPayment') {
                return Tab(
                  child: tabLabelText('Bank Payment'),
                );
              }
              if (listPaymentGateways[index].title == 'razorPayment') {
                return Tab(
                  child: tabLabelText('RazorPay'),
                );
              }
              if (listPaymentGateways[index].title == 'paytmPayment') {
                return Tab(
                  child: tabLabelText('Paytm'),
                );
              }
              if (listPaymentGateways[index].title == 'paypalPayment') {
                return Tab(
                  child: tabLabelText('PayPal'),
                );
              }
              if (listPaymentGateways[index].title == 'inapp') {
                return Tab(
                  child: tabLabelText('In App'),
                );
              }
              return null;
            },
          ) as List<Widget>,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColorLight,
        pinned: true,
        floating: true,
      ),
      preferredSize: Size.fromHeight(0.0),
    );
  }

//  App bar material design
  Widget appbarMaterialDesign() {
    return Material(
      child: Container(
        height: 80.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.amber.withOpacity(0.6),
              Colors.amber.withOpacity(0.4),
              Colors.amber.withOpacity(0.2),
              Colors.amber.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

//  Select payment text
  Widget selectPaymentText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 40.0),
        ),
        Expanded(
          child: Text(
            'Select Payment',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

//  Plan name and user name
  Widget planAndUserName(indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    var name =
        Provider.of<UserProfileProvider>(context).userProfileModel!.user!.name!;
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${planDetails[widget.planIndex].name}",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.white, fontSize: 12.0, height: 1.3),
                  ),
                ],
              )),
        ],
      ),
    );
  }

//  Minimum duration
  Widget minDuration(indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Min duration ' +
                  '${planDetails[indexPer].intervalCount}' +
                  ' days',
              style:
                  TextStyle(color: Colors.white, fontSize: 12.0, height: 1.3),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Text(
              new DateFormat.yMMMd().format(new DateTime.now()),
              style:
                  TextStyle(color: Colors.white70, fontSize: 12.0, height: 1.5),
            ),
          ],
        ));
  }

//  After applying coupon
  Widget couponProcessing(afterDiscountAmount, indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              discountText(),
              Expanded(
                  flex: 1,
                  child: validCoupon == true
                      ? Text(
                          percentOFF.toString() + " %",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12.0, height: 1.3),
                        )
                      : Text(
                          "0 %",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12.0, height: 1.3),
                        )),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              afterDiscountText(),
              Expanded(
                flex: 1,
                child: validCoupon == true
                    ? Text(
                        afterDiscountAmount.toString() +
                            " ${planDetails[widget.planIndex].currency}",
                        style: TextStyle(
                            color: Colors.white, fontSize: 12.0, height: 1.3),
                      )
                    : amountText(indexPer),
              ),
            ],
          )
        ],
      ),
    );
  }

//  Plan amount
  Widget planAmountText(indexPer, dailyAmountAp) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "${planDetails[widget.planIndex].amount}" +
                  " ${planDetails[widget.planIndex].currency}".toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 3.0,
          ),
          Container(
            child: Text(
              '( $dailyAmountAp' +
                  ' ${planDetails[widget.planIndex].currency} / ${planDetails[widget.planIndex].currency} )',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                  letterSpacing: 0.8,
                  height: 1.3,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

//  Logo row
  Widget logoRow() {
    var logo =
        Provider.of<AppConfig>(context, listen: false).appModel!.config!.logo;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 12.0, right: 10.0),
          child: Image.network(
            '${APIData.logoImageUri}$logo',
            scale: 1.7,
          ),
        ),
      ],
    );
  }

//  Discount percent
  Widget discountText() {
    return Expanded(
      flex: 5,
      child: Text(
        "Discount",
        style: TextStyle(color: Colors.white, fontSize: 12.0, height: 1.3),
      ),
    );
  }

//  Amount after discount
  Widget afterDiscountText() {
    return Expanded(
      flex: 5,
      child: Text(
        "After Discount Amount:",
        style: TextStyle(color: Colors.white, fontSize: 12.0, height: 1.3),
      ),
    );
  }

//  Amount
  Widget amountText(indexPer) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    return Text(
      "${planDetails[indexPer].amount}" + " ${planDetails[indexPer].currency}",
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        height: 1.3,
      ),
    );
  }

//  Tab label text
  Widget tabLabelText(label) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Text(
        label,
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 13.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
            color: Colors.white),
      ),
    );
  }

// Swipe down row
  Widget swipeDownRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        swipeIconContainer(),
        SizedBox(
          width: 10.0,
        ),
        swipeDownText(),
      ],
    );
  }

// Swipe icon container
  Widget swipeIconContainer() {
    return Container(
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.amber),
          shape: BoxShape.circle,
          color: Theme.of(context).backgroundColor),
      child: Icon(Icons.keyboard_arrow_down,
          size: 21.0, color: Colors.white.withOpacity(0.7)),
    );
  }

//  Swipe down text
  Widget swipeDownText() {
    return Text(
      "Swipe down wallet to pay",
      style: TextStyle(fontSize: 16.0, color: Colors.white.withOpacity(0.7)),
    );
  }

  //  Bank payment wallet
  Widget bankPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BankPayment()));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BankPayment()));
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/bankwallets.png"),
                )),
          ],
        ),
      ),
    );
  }

  //  Razorpay payment wallet
  Widget razorPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.razorpay,
                          arguments: RazorPayment(indexPer, null));
                    } else {
                      Navigator.pushNamed(context, RoutePaths.razorpay,
                          arguments: RazorPayment(indexPer, genCoupon));
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/razorpay.png"),
                )),
          ],
        ),
      ),
    );
  }

  //  Paytm payment wallet
  Widget paytmPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.paytm,
                          arguments: PaytmPayment(indexPer, null));
                      return Future.value(
                          direction == DismissDirection.endToStart);
                    } else {
                      Navigator.pushNamed(context, RoutePaths.paytm,
                          arguments: PaytmPayment(indexPer, genCoupon));
                      return Future.value(
                          direction == DismissDirection.endToStart);
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                    return Future.value(
                        direction == DismissDirection.endToStart);
                  }
                  return Future.value(direction == DismissDirection.endToStart);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/paytm.png"),
                )),
          ],
        ),
      ),
    );
  }

//  Paystack payment wallet
  Widget paystackPaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
            swipeDownRow(),
            Dismissible(
                direction: DismissDirection.down,
                key: Key("$indexPer"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return true;
                  }
                  if (couponCode == '') {
                    if (genCoupon == null) {
                      Navigator.pushNamed(context, RoutePaths.paystack,
                          arguments: PaystackPayment(indexPer, null));
                    } else {
                      Navigator.pushNamed(context, RoutePaths.paystack,
                          arguments: PaystackPayment(indexPer, genCoupon));
                    }
                  } else {
                    Future.delayed(Duration(seconds: 1)).then((_) {
                      Fluttertoast.showToast(
                          msg: "Coupon is only applicable to Stripe");
                    });
                  }
                  return null;
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 0.0, 100.0, 0.0),
                  child: Image.asset("assets/paystackwallets.png"),
                )),
          ],
        ),
      ),
    );
  }

//  Stripe payment wallet
  Widget stripePaymentWallet(indexPer) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.amber,
            ),
            child: Text(
              "CONTINUE TO PAYMENT",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              if (validCoupon != false || couponCode == '') {
                if (genCoupon == null) {
                  Navigator.pushNamed(context, RoutePaths.stripe,
                      arguments:
                          // StripeTest());
                          StripePayment(indexPer, couponCode));
                } else {
                  Fluttertoast.showToast(
                      msg:
                          "This coupon can't be applicable for Stripe payment");
                }
              }
              Future.delayed(Duration(seconds: 1)).then((_) {
                validCoupon == false
                    ? Fluttertoast.showToast(msg: couponMSG)
                    : SizedBox.shrink();
              });
              return null;
            }),
      ),
    );
  }

//  Braintree payment wallet
  Widget braintreePayment(indexPer) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              if (couponCode == '') {
                if (genCoupon == null) {
                  Navigator.pushNamed(context, RoutePaths.braintree,
                      arguments: BraintreePaymentScreen(indexPer, null));
                } else {
                  Navigator.pushNamed(context, RoutePaths.braintree,
                      arguments: BraintreePaymentScreen(indexPer, genCoupon));
                }
              } else {
                Future.delayed(Duration(seconds: 1)).then((_) {
                  Fluttertoast.showToast(
                      msg: "Coupon is only applicable to Stripe");
                });
              }
            },
            child: Text("CONTINUE"),
          ),
        ));
  }

  //  paypal payment wallet
  Widget paypalPayment(indexPer) {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel;
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              if (couponCode == '') {
                if (genCoupon == null) {
                  onPayWithPayPal(appConfig, userDetails, indexPer, null);
                } else {
                  onPayWithPayPal(appConfig, userDetails, indexPer, genCoupon);
                }
              } else {
                Future.delayed(Duration(seconds: 1)).then((_) {
                  Fluttertoast.showToast(
                      msg: "Coupon is only applicable to Stripe");
                });
              }
            },
            child: Text("CONTINUE"),
          ),
        ));
  }

  void onPayWithPayPal(appConfig, userDetails, indexPer, amount) {
    Navigator.pushNamed(
      context,
      RoutePaths.paypal,
      arguments: PaypalPayment(
        onFinish: (number) async {},
        currency: "${appConfig.config.currencyCode}",
        userFirstName: userDetails.user.name,
        userLastName: "",
        userEmail: userDetails.user.email,
        payAmount:
            amount == null ? "${appConfig.plans[indexPer].amount}" : "$amount",
        planIndex: appConfig.plans[widget.planIndex].id,
      ),
    );
  }

  //  inapp payment wallet
  Widget inappPayment(indexPer) {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.amber,
          ),
          child: Text(
            "CONTINUE TO PAYMENT",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            if (couponCode == '') {
              if (genCoupon == null) {
                Navigator.pushNamed(context, RoutePaths.inApp,
                    arguments: InApp(indexPer));
              } else {
                Fluttertoast.showToast(
                    msg: "Coupon can't be applied for this payment gateway");
                return;
              }
            } else {
              Future.delayed(Duration(seconds: 1)).then((_) {
                Fluttertoast.showToast(
                    msg: "Coupon is only applicable to Stripe");
              });
            }
          },
        ),
      ),
    );
  }

//  Sliver List
  Widget _sliverList(dailyAmountAp, afterDiscountAmount, planDetails) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int j) {
      return Container(
          child: Column(children: <Widget>[
        new Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  appbarMaterialDesign(),
                  Container(
                    margin: EdgeInsets.only(top: 60.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.5,
                          // aspectRatio:
                          //     validCoupon == true ? 16.0 / 15.0 : 16.0 / 13.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                              ),
                              selectPaymentText(),
                              planAndUserName(widget.planIndex),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0),
                                    ),
                                    minDuration(widget.planIndex),
                                    planAmountText(
                                        widget.planIndex, dailyAmountAp),
                                  ],
                                ),
                              ),
                              // Padding(padding: EdgeInsets.only(top: 40.0)),
                              // InkWell(
                              //   child: Container(
                              //     margin:
                              //         EdgeInsets.only(left: 20.0, right: 20.0),
                              //     height: 50.0,
                              //     width: MediaQuery.of(context).size.width,
                              //     child: Row(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.center,
                              //       children: <Widget>[
                              //         Expanded(
                              //           flex: 5,
                              //           child: Row(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.start,
                              //             children: <Widget>[
                              //               giftIcon(),
                              //               Padding(
                              //                   padding:
                              //                       EdgeInsets.only(left: 10.0),
                              //                   child: isCouponApplied
                              //                       ? Text("Apply Coupon")
                              //                       : Text(
                              //                           couponCode,
                              //                           textAlign:
                              //                               TextAlign.left,
                              //                         ))
                              //             ],
                              //           ),
                              //         ),
                              //         applyCouponIcon(),
                              //       ],
                              //     ),
                              //     decoration: BoxDecoration(
                              //       border: Border.all(
                              //         width: 2.0,
                              //         color: Colors.white.withOpacity(0.4),
                              //       ),
                              //     ),
                              //   ),
                              //   onTap: () {
                              //     Navigator.pushNamed(
                              //         context, RoutePaths.applyCoupon,
                              //         arguments: ApplyCouponScreen(
                              //             planDetails[widget.planIndex]
                              //                 .amount));
                              //   },
                              // ),
                              Container(
                                  height: 30.0,
                                  child: isCouponApplied
                                      ? SizedBox.shrink()
                                      : Padding(
                                          padding: EdgeInsets.only(left: 40.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              validCoupon == true
                                                  ? Icon(
                                                      FontAwesomeIcons
                                                          .solidCheckCircle,
                                                      color: activeDotColor,
                                                      size: 13.0,
                                                    )
                                                  : Icon(
                                                      FontAwesomeIcons
                                                          .solidTimesCircle,
                                                      color: Colors.red,
                                                      size: 13.0,
                                                    ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                couponMSG,
                                                style: TextStyle(
                                                    color: validCoupon == true
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.7),
                                              ),
                                            ],
                                          ),
                                        )),
                              validCoupon == true
                                  ? couponProcessing(
                                      afterDiscountAmount, widget.planIndex)
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                        Container(
                          height: 2.0,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  new Positioned(
                    top: 8.0,
                    left: 4.0,
                    child: new BackButton(color: Colors.white),
                  ),
                  logoRow(),
                ],
              ),
            ],
          ),
        ),
      ]));
    },
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: true,
            childCount: 1));
  }

//  Scaffold body
  Widget _scaffoldBody(dailyAmountAp, afterDiscountAmount, planDetails) {
    return NestedScrollView(
      physics: ClampingScrollPhysics(),
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _sliverList(dailyAmountAp, afterDiscountAmount, planDetails),
          // paymentMethodTabs(),
        ];
      },
      body: _nestedScrollViewBody(),
    );
  }

//  NestedScrollView body
  Widget _nestedScrollViewBody() {
    return listPaymentGateways.length == 0
        ? Center(
            child: Text("No payment method available"),
          )
        : TabBarView(
            controller: _paymentTabController,
            physics: PageScrollPhysics(),
            children: List<Widget?>.generate(
                listPaymentGateways == null ? 0 : listPaymentGateways.length,
                (int index) {
              if (listPaymentGateways[index].title == 'btree') {
                return InkWell(
                  child: braintreePayment(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'stripe') {
                return InkWell(
                  child: stripePaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'paystack') {
                return InkWell(
                  child: paystackPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'bankPayment') {
                return InkWell(
                  child: bankPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'razorPayment') {
                return InkWell(
                  child: razorPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'paytmPayment') {
                return InkWell(
                  child: paytmPaymentWallet(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'paypalPayment') {
                return InkWell(
                  child: paypalPayment(widget.planIndex),
                );
              }
              if (listPaymentGateways[index].title == 'inapp') {
                return InkWell(
                  child: inappPayment(widget.planIndex),
                );
              }
              return null;
            }) as List<Widget>);
  }

//  Build method
  @override
  Widget build(BuildContext context) {
    var planDetails = Provider.of<AppConfig>(context).planList;
    var dailyAmount1;
    var intervalCount;
    dynamic planAm = planDetails[widget.planIndex].amount;
    switch (planAm.runtimeType) {
      case int:
        dailyAmount1 = planAm;
        break;
      case String:
        dailyAmount1 = double.parse(planAm);
        break;
      case double:
        dailyAmount1 = double.parse(planAm);
        break;
    }
    dynamic interCount = planDetails[widget.planIndex].intervalCount;
    switch (interCount.runtimeType) {
      case int:
        intervalCount = interCount;
        break;
      case String:
        intervalCount = int.parse(interCount);
        break;
    }
    var dailyAmount = dailyAmount1 / intervalCount;
    String? dailyAmountAp = dailyAmount.toStringAsFixed(2);
    var amountOff = validCoupon == true
        ? (percentOFF / 100) * planDetails[widget.planIndex].amount
        : 0;
    var afterDiscountAmount = validCoupon == true
        ? planDetails[widget.planIndex].amount - amountOff
        : 0;

    return SafeArea(
      child: WillPopScope(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              key: _scaffoldKey,
              body: loading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _scaffoldBody(
                      dailyAmountAp, afterDiscountAmount, planDetails),
            ),
          ),
          onWillPop: () async {
            return true;
          }),
    );
  }
}

class PaymentGateInfo {
  String? title;
  int? status;

  PaymentGateInfo({this.title, this.status});
}
