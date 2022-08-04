import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EsperaRegistro extends StatefulWidget {
  const EsperaRegistro({Key? key}) : super(key: key);

  @override
  State<EsperaRegistro> createState() => _EsperaRegistroState();
}

class _EsperaRegistroState extends State<EsperaRegistro> {
  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );

    return Scaffold(body: Center(child: spinkit));
  }
}
