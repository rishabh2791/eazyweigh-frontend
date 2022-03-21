import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/screen_type.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:flutter/material.dart';

class SuperPageWidget extends StatefulWidget {
  final ScreenType screenType;
  final Widget childWidget;
  final Animation<double> scaleAnimation;
  const SuperPageWidget(
      {Key? key,
      required this.childWidget,
      required this.screenType,
      required this.scaleAnimation})
      : super(key: key);

  @override
  _SuperPageWidgetState createState() => _SuperPageWidgetState();
}

class _SuperPageWidgetState extends State<SuperPageWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: animationDuration,
      right: isMenuCollapsed
          ? 0
          : widget.screenType == ScreenType.mobile
              ? size.width * 0.6
              : widget.screenType == ScreenType.tablet
                  ? size.width * 0.5
                  : size.width * 0.1,
      left: isMenuCollapsed
          ? 0
          : widget.screenType == ScreenType.mobile
              ? -size.width * 0.4
              : widget.screenType == ScreenType.tablet
                  ? -size.width * 0.5
                  : -size.width * 0.1,
      top: 0,
      bottom: 0,
      child: ScaleTransition(
        scale: widget.scaleAnimation,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
          elevation: 5.0,
          child: Stack(
            children: [
              Container(
                height: size.height,
                decoration: BoxDecoration(
                  borderRadius: isMenuCollapsed
                      ? const BorderRadius.all(Radius.circular(0.0))
                      : const BorderRadius.all(Radius.circular(20.0)),
                  color: isDarkTheme ? backgroundColor : foregroundColor,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: widget.childWidget,
                      ),
                    ],
                  ),
                ),
              ),
              isMenuCollapsed
                  ? Container()
                  : Container(
                      height: size.height,
                      color: Colors.transparent,
                      child: const Center(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
