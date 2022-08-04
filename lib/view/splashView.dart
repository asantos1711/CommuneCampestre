import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/splashProvider.dart';

class LoadingScreen {
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoadingCustom(child: child!));
      } else {
        return LoadingCustom(child: child!);
      }
    };
  }
}

class LoadingCustom extends StatelessWidget {
  final Widget child;
  LoadingCustom({Key? key, required this.child}) : super(key: key);
  late double w, h;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: ChangeNotifierProvider<LoadingProvider>(
            create: (context) => LoadingProvider(),
            builder: (context, _) {
              return Stack(children: [
                new GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: child),
                Consumer<LoadingProvider>(builder: (context, provider, child) {
                  return provider.loading
                      ? Container(
                          width: w,
                          height: h,
                          color: Color.fromARGB(146, 0, 0, 0),
                          child: Center(
                              child: Image.asset(
                            "assets/icon/casita.gif",
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          )),
                        )
                      : SizedBox();
                })
              ]);
            }));
  }
}
