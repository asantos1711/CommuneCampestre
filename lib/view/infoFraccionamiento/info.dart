import 'package:campestre/widgets/columnBuilder.dart';
import 'package:flutter/material.dart';

import '../../models/NoticiasModel.dart';
import '../../services/apiResidencial/registroUsuarios.dart';

class InfoFraccionamiento extends StatefulWidget {
  const InfoFraccionamiento({Key? key}) : super(key: key);

  @override
  State<InfoFraccionamiento> createState() => _InfoFraccionamientoState();
}

class _InfoFraccionamientoState extends State<InfoFraccionamiento> {
  double w = 0.0, h = 0.0;
  RegistroUsuarioConnect db = RegistroUsuarioConnect();

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Información",
            style: TextStyle(fontSize: 20, color: Color(0xFF06323D))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: db.getNewsLetter(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<NewsLetterList> lista = snapshot.data;

            if (lista.isEmpty) {
              return Center(
                child: Text("No hay información para mostrar por el momento"),
              );
            }

            return ColumnBuilder(
              itemCount: lista.length,
              itemBuilder: (c, i) {
                return _content(lista[i]);
              },
            );
          },
        ),
      ),
    );
  }

  _content(NewsLetterList item) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 15, left: 15),
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(35.0) //                 <--- border radius here
            ),
      ),
      child: Card(
        child: Container(
          //padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: w * 0.9,
              alignment: Alignment.center,
              //height: 100,
              child: Image.network(
                item.url.toString(),
                fit: BoxFit.fitWidth,
                height: h * 0.25,
              ),
            ),
            Container(
              //height: 100,
              padding: EdgeInsets.all(10),
              child: Text(
                item.name.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                item.descripcion.toString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
