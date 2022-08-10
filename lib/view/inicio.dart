
import 'package:campestre/widgets/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  UIHelper u = new UIHelper();
  double? w, h;
 
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: u.bottomBar(h, w!, 0, context),

      body: Stack(
          children: <Widget>[
            ListView(
            children: [
              Container(
                width: w! - 50,
                // height: 800,
                margin: EdgeInsets.only(top: h! / 40, left: 20, right: 20),
               /*decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 10.0,
                    ),
                  ],
                  border: Border.all(width: 1, style: BorderStyle.none),
                  borderRadius: BorderRadius.all(Radius.circular(25))),*/
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Container(child:Text("Estado de cuenta", style: TextStyle(color: Color(0xFF434343), fontSize:22))),
                    SizedBox(
                      height: 15,
                    ),

                    Container(
                      width: w!-50,
                     // margin: EdgeInsets.only(left:20, right:20),
                     // height: h/4,
                     padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[500]!,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 10.0,
                          ),
                        ],
                        border: Border.all(width: 1, style: BorderStyle.none),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0) //         <--- border radius here
                        )
                      ),
                      child: Column(children: [
                        Text("Diciembre 2020", style: TextStyle(fontSize: 20, color: Color(0xFF434343), fontWeight: FontWeight.w600),),
                        SizedBox(height:15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [                          
                          Text("Pagado", style: TextStyle(fontSize: 16, color: Color(0xFF434343), fontWeight: FontWeight.w400),),
                          Icon(FontAwesome.check_circle, color: Color(0xFFAAD106),),
                        ],),
                        SizedBox(height:15),
                        Text("Monto \$500", style: TextStyle(fontSize: 16, color: Color(0xFF434343), fontWeight: FontWeight.w400),),
                        SizedBox(height:15),
                        /*Container(
                          width: w/3,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0) //         <--- border radius here
                            )
                          ),
                          child:Text("Pagar", style: TextStyle(fontSize: 16, color: Colors.white),textAlign: TextAlign.center,)
                        )*/
                      ],),
                    ),
                    SizedBox(height:30),
                    Container(
                      width: w!-50,
                     // margin: EdgeInsets.only(left:20, right:20),
                     // height: h/4,
                     padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[500]!,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 10.0,
                          ),
                        ],
                        border: Border.all(width: 1, style: BorderStyle.none),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0) //         <--- border radius here
                        )
                      ),
                      child: Column(children: [
                        Text("Enero 2020", style: TextStyle(fontSize: 20, color: Color(0xFF434343), fontWeight: FontWeight.w600),),
                        SizedBox(height:15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [                          
                          Text("Pendiente", style: TextStyle(fontSize: 16, color: Color(0xFF434343), fontWeight: FontWeight.w400),),
                          Icon(FontAwesome.times_circle, color: Colors.red,),
                        ],),
                        SizedBox(height:15),
                        Text("Monto \$500", style: TextStyle(fontSize: 16, color: Color(0xFF434343), fontWeight: FontWeight.w400),),
                        SizedBox(height:15),
                        Container(
                          width: w!/3,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0) //         <--- border radius here
                            )
                          ),
                          child:Text("Pagar", style: TextStyle(fontSize: 16, color: Colors.white),textAlign: TextAlign.center,)
                        )
                      ],),
                    ),
                    SizedBox(height:30),
                    Container(
                      width: w!-50,
                     // margin: EdgeInsets.only(left:20, right:20),
                     // height: h/4,
                     padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[500]!,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 10.0,
                          ),
                        ],
                        border: Border.all(width: 1, style: BorderStyle.none),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0) //         <--- border radius here
                        )
                      ),
                      child: Column(children: [
                        Text("Febrero 2020", style: TextStyle(fontSize: 20, color: Color(0xFF434343), fontWeight: FontWeight.w600),),
                        SizedBox(height:15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [                          
                          Text("Pendiente", style: TextStyle(fontSize: 16, color: Color(0xFF434343), fontWeight: FontWeight.w400),),
                          Icon(FontAwesome.times_circle, color: Colors.red,),
                        ],),
                        SizedBox(height:15),
                        Text("Monto \$500", style: TextStyle(fontSize: 16, color: Color(0xFF434343), fontWeight: FontWeight.w400),),
                        SizedBox(height:15),
                        Container(
                          width: w!/3,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0) //         <--- border radius here
                            )
                          ),
                          child:Text("Pagar", style: TextStyle(fontSize: 16, color: Colors.white),textAlign: TextAlign.center,)
                        )
                      ],),
                    ),
                    SizedBox(
                      height: 30,
                    ),                    
                  ]),
              )
              ])
            ]) 
    );
  }
}