import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/models/menu_model.dart';
import 'package:http/http.dart' as http;
import 'package:nexthour/common/route_paths.dart';

class MenuProvider with ChangeNotifier {
  MenuModel menuModel = new MenuModel();
  List<Menu> menuList = [];

  Future<MenuModel> getMenus(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(APIData.topMenu), headers: {
        // "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $authToken",
      });
      if (response.statusCode == 200) {
        menuModel = MenuModel.fromJson(json.decode(response.body));
        menuList = List.generate(menuModel.menu!.length, (index) {
          return Menu(
            id: menuModel.menu![index].id,
            name: menuModel.menu![index].name,
            slug: menuModel.menu![index].slug,
            position: menuModel.menu![index].position,
            createdAt: menuModel.menu![index].createdAt,
            updatedAt: menuModel.menu![index].updatedAt,
          );
        });
      } else if (response.statusCode == 401) {
        await storage.deleteAll();
        Navigator.pushNamed(context, RoutePaths.loginHome);
        // Navigator.pushNamed(context, RoutePaths.introSlider);
        throw "Can't get menus";
      } else {
        throw "Can't get menus";
      }
      notifyListeners();
      return menuModel;
    } catch (e) {
      await storage.deleteAll();
      Navigator.pushNamed(context, RoutePaths.loginHome);
      // Navigator.pushNamed(context, RoutePaths.introSlider);
      throw "Can't get menus";
    }
  }
}
