import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/auth_interface/login_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void refreshToken(int delay) async {
  String token;
  var timeOut = defaultTimeOut;
  bool loggedIn = false;
  Map<String, String> headers = {};
  SharedPreferences storage = await SharedPreferences.getInstance();

  token = storage.getString("refresh_token") ?? "";
  timeOut = storage.getInt("access_validity") ?? defaultTimeOut;
  loggedIn = storage.getBool("logged_in") ?? false;

  Future.delayed(Duration(seconds: delay), () async {
    if (token != "" && loggedIn) {
      await storage.setBool("logged_in", false);
      headers["Authorization"] = "RefreshToken " + token;
      isRefreshing = true;
      if (isLoadingServerData) {
        Future.delayed(const Duration(seconds: 1), () {
          refreshToken(0);
        });
      } else {
        await appStore.authApp.refresh(headers).then((response) async {
          if (response["status"]) {
            var payload = response["payload"];
            await storage.setString("access_token", payload["AccessToken"]);
            await storage.setString('refresh_token', payload["RefreshToken"]);
            await storage.setInt("access_validity", payload["ATDuration"]);
            await storage.setBool("logged_in", true);
          } else {
            navigationService.pushReplacement(CupertinoPageRoute(
                builder: (BuildContext context) => const LoginWidget()));
          }
        });
      }
    } else {
      navigationService.pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) => const LoginWidget()));
    }
    isRefreshing = false;
    if (isLoggedIn) {
      Future.delayed(Duration(seconds: timeOut - 2), () {
        refreshToken(0);
      });
    }
  });
}
