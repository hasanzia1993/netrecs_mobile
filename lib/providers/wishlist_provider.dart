import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/models/wishlist_model.dart';
import 'package:http/http.dart' as http;

class WishListProvider with ChangeNotifier {
  WishListModel? wishListModel;

  Future<WishListModel?> getWishList(BuildContext context) async {
    var token = await storage.read(key: "authToken");
    final response = await http.get(Uri.parse(APIData.watchListApi), headers: {
      // HttpHeaders.contentTypeHeader: "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    if (response.statusCode == 200) {
      wishListModel = WishListModel.fromJson(json.decode(response.body));
    } else {
      throw "Can't get wish list data";
    }
    notifyListeners();
    return wishListModel;
  }
}
