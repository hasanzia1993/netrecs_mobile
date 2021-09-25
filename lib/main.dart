// @dart=2.9
// --no-sound-null-safety

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'common/global.dart';
import 'my_app.dart';
import 'package:nexthour/services/repository/database_creator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterDownloader.initialize();
  await DatabaseCreator().initDatabase();

  authToken = await storage.read(key: "token");
  runApp(MyApp(
    token: authToken,
  ));
}
