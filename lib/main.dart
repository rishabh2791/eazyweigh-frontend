import 'package:eazyweigh/infrastructure/scanner.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/socket_utility.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/auth_interface/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  scannerListener.barcodeListener();
  socketUtility.initCommunication();
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> store = SharedPreferences.getInstance();
  storage = await store;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EazyWeigh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigationService.navigatorKey,
      home: const LoginWidget(),
    );
  }
}
