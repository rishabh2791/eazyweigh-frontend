import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}
