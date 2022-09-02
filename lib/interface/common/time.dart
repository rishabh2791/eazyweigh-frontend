import 'dart:async';

import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:eazyweigh/interface/common/super_widget/super_menu_widget.dart';

void initializeTimer() {
  if (rootTimer.isActive) {
    rootTimer.cancel();
  }
  rootTimer = Timer(Duration(seconds: defaultTimeout), () {
    if (isLoggedIn) {
      logout();
    }
  });
}

void handleUserInteraction([_]) {
  if (isLoggedIn) {
    rootTimer.cancel();
    initializeTimer();
  }
}
