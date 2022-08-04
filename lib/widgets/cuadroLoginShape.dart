import 'package:flutter/material.dart';

import '../bloc/usuario_bloc.dart';

class CurvedPainter extends CustomPainter {
  UsuarioBloc usuarioBloc = new UsuarioBloc();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color.fromARGB(
          255,
          usuarioBloc.miFraccionamiento.color!.r,
          usuarioBloc.miFraccionamiento.color!.g,
          usuarioBloc.miFraccionamiento.color!.b)
      ..strokeWidth = 15;

    var path = Path();

    path.moveTo(0, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.8, size.height * .8, size.width * 0.7,
        size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.5,
        size.width * .5, size.height * .5);
    path.quadraticBezierTo(
        size.width * 0.1, size.height * 0.55, size.width * 0, size.height * .4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
