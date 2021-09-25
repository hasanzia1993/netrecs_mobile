import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/models/app_model.dart';
import 'package:nexthour/models/block.dart';
import 'package:nexthour/models/plans_model.dart';

import '../common/route_paths.dart';

class AppConfig with ChangeNotifier {
  AppModel? appModel;
  List<Block> slides = [];
  List<Plan> planList = [];

  Future<AppModel?> getHomeData(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(APIData.homeDataApi), headers: {
        // "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      print("response: ${response.statusCode}");
      if (response.statusCode == 200) {
        appModel = AppModel.fromJson(json.decode(response.body));
        slides = List.generate(
            appModel!.blocks!.length,
            (index) => Block(
                  id: appModel!.blocks![index].id,
                  image: appModel!.blocks![index].image,
                  heading: appModel!.blocks![index].heading,
                  detail: appModel!.blocks![index].detail,
                  position: appModel!.blocks![index].position,
                  buttonText: appModel!.blocks![index].buttonText,
                ));
        planList = List.generate(
            appModel!.plans!.length,
            (index) => Plan(
                  id: appModel!.plans![index].id,
                  name: appModel!.plans![index].name,
                  currency: appModel!.plans![index].currency,
                  currencySymbol: appModel!.plans![index].currencySymbol,
                  amount: appModel!.plans![index].amount,
                  interval: appModel!.plans![index].interval,
                  intervalCount: appModel!.plans![index].intervalCount,
                  trialPeriodDays: appModel!.plans![index].trialPeriodDays,
                  status: appModel!.plans![index].status,
                  screens: appModel!.plans![index].screens,
                  deleteStatus: appModel!.plans![index].deleteStatus,
                  download: appModel!.plans![index].download,
                  downloadlimit: appModel!.plans![index].downloadlimit,
                  updatedAt: appModel!.plans![index].updatedAt,
                  createdAt: appModel!.plans![index].createdAt,
                  planId: appModel!.plans![index].planId,
                  pricingTexts: appModel!.plans![index].pricingTexts,
                ));
        planList.removeWhere(
            (element) => element.status == 0 || element.status == "0");
      } else {
        throw "Can't get home data";
      }
      notifyListeners();
      return appModel;
    } catch (error) {
      print('error');
      print(error);
      Navigator.pushNamed(context, RoutePaths.login);
      throw error;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
