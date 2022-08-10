import 'package:campestre/view/inicio.dart';
import 'package:campestre/view/invitadosList.dart';
import 'package:campestre/view/menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UIHelper {
  Widget bottomBar(double? h, double w, int position, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 70,
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              if (position != 0) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => Inicio(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              }
            },
            child: Container(
              width: w / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Icon(
                    FontAwesomeIcons.house,
                    color: position == 0 ? Color(0xFF5562A1) : Colors.black,
                  ),
                  SizedBox(height: 5),
                  Text("Inicio",
                      style: TextStyle(
                          fontSize: 12,
                          color: position == 0
                              ? Color(0xFF5562A1)
                              : Colors.black)),
                ],
              ),
            ),
          ),
          InkWell(
              onTap: () {
                if (position != 1) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          InvitadosList(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                }
              },
              child: Container(
                width: w / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.users,
                      color: position == 1 ? Color(0xFF5562A1) : Colors.black,
                    ),
                    SizedBox(height: 5),
                    Text("Invitados",
                        style: TextStyle(
                            fontSize: 12,
                            color: position == 1
                                ? Color(0xFF5562A1)
                                : Colors.black))
                  ],
                ),
              )),
          InkWell(
              onTap: () {
                if (position != 2) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          ConfigView(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                }
              },
              child: Container(
                width: w / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Icon(FontAwesomeIcons.bars,
                        color:
                            position == 2 ? Color(0xFF5562A1) : Colors.black),
                    SizedBox(height: 5),
                    Text("Menú",
                        style: TextStyle(
                            fontSize: 12,
                            color: position == 2
                                ? Color(0xFF5562A1)
                                : Colors.black))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  static Widget bloqueaPantalla(BuildContext context, bool status) {
    Widget widget = Container();

    if (status) {
      widget = Positioned(
        bottom: 0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration:
                BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.5)),
            child: Center(
              child: Image.asset(
                "assets/icon/casita.gif",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            )),
      );
    } else {
      widget = SizedBox();
    }

    return widget;
  }
}
