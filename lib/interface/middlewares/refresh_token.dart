import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/infrastructure/services/navigator_services.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/auth_interface/login_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> refreshAccessToken() async {
  String token;
  bool loggedIn = false;
  SharedPreferences storage = await SharedPreferences.getInstance();

  token = storage.getString("refresh_token") ?? "";
  loggedIn = storage.getBool("logged_in") ?? false;

  if (token != "" && loggedIn) {
    await storage.setBool("logged_in", false);
    isRefreshing = true;

    await appStore.authApp.refresh().then((response) async {
      if (response["status"]) {
        var payload = response["payload"];
        await storage.setString("access_token", payload["AccessToken"]);
        await storage.setString('refresh_token', payload["RefreshToken"]);
        await storage.setInt("access_validity", payload["ATDuration"]);
        await storage.setBool("logged_in", true);
        isLoggedIn = true;
        isRefreshing = false;
        accessTokenExpiryTime = DateTime.now().add(
            Duration(seconds: int.parse(payload["ATDuration"].toString())));
      } else {
        navigationService.pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => const LoginWidget()));
      }
    });
  }
}
