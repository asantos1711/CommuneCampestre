import 'package:campestre/view/menuInicio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReporteSucess extends StatefulWidget {
  const ReporteSucess({Key? key}) : super(key: key);

  @override
  State<ReporteSucess> createState() => _ReporteSucessState();
}

class _ReporteSucessState extends State<ReporteSucess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Acceso a visitas",
          style: TextStyle(
              fontSize: 20,
              color: Color(0xFF06323D),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xFF0C0C0C),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Icon(
              FontAwesomeIcons.circleCheck,
              size: 60,
              color: Color(0xFF5E1281),
            ),
          ),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40),
              child: Text(
                "Reporte envíado",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              )),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 50, right: 50, top: 20),
            child: Text(
              "Se ha enviado el reporte a administración",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9B9B9B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10, top: 20, right: 80, left: 80),
            child: TextButton(
              //minWidth: 100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuInicio()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor:const Color(0xff5E1281),
                padding:const EdgeInsets.all(0),
              ),
              child:const Text(
                "Inicio",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          /*Container(
            margin: EdgeInsets.only(bottom: 20, top: 0, right: 30, left: 30),
            padding: EdgeInsets.all(10),
            child: FlatButton(
              //minWidth: 100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuInicio()),
                );
              },
              color: Colors.white,
              shape: RoundedRectangleBorder(                  
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text(
                "Mi cuenta",
                style: TextStyle(fontSize: 15, color: Color(0xff5E1281)),
              ),
            ),
          )*/
        ],
      ),
    );
  }
}
