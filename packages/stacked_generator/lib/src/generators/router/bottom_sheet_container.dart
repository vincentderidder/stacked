import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  const BottomSheetContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = 10 + topSafeAreaPadding;

    final _shadow =
        BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 5);
    BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 5);
    return Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                boxShadow: [_shadow]),
            width: double.infinity,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true, //Remove top Safe Area
              child: child,
            ),
          ),
        ));
  }
}
