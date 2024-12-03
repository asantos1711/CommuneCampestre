import 'dart:convert';
import 'dart:io';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/eventoModel.dart';
import 'package:campestre/models/eventoModel.dart' as Evento;
import 'package:campestre/models/invitadoModel.dart';
import 'package:campestre/view/eventos/datosInvidato.dart';
import 'package:campestre/widgets/columnBuilder.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:campestre/widgets/ui_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shortener/bitly_shortener.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../provider/splashProvider.dart';

class VisitasEventosPage extends StatefulWidget {
  String? id;
  VisitasEventosPage({this.id});

  @override
  State<VisitasEventosPage> createState() => _VisitasEventosPageState();
}

class _VisitasEventosPageState extends State<VisitasEventosPage> {
  UIHelper u = new UIHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombre = new TextEditingController();
  TextEditingController _fecha = new TextEditingController();
  TextEditingController _hora = new TextEditingController();
  DatabaseServices db = new DatabaseServices();
  DateTime selectedDate = new DateTime.now();
  TimeOfDay _fromTime = new TimeOfDay.now();
  EventoModel? _evento = new EventoModel();
  double? w, h;
  final picker = ImagePicker();
  File? _image;
  UsuarioBloc usuarioBloc = UsuarioBloc();
  bool? onCharge;
  bool typePhoto = false;
  bool typePhotoPlaca = false;
  bool isSaved = false;
  String? id;
  List<Invitado> lista = [];
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    //bloquearPantalla();

    _initData();
    super.initState();
  }

  _initData() async {
    if (this.widget.id != null && this.widget.id!.isNotEmpty) {
      DatabaseServices databaseServices = new DatabaseServices();
      print(":ID :" + this.widget.id.toString());
      _evento = await databaseServices.getEvento(
          this.widget.id ?? ""); //05377b8df7c4592cf03f0dc9696a41bb5bd655a5

      if (_evento != null && _evento!.id!.isNotEmpty) {
        setState(() {
          isSaved = true;
        });
        DateTime? fe = _evento!.tiempos!.fechaEntrada;
        _nombre.text = _evento!.nombre.toString();
        _fecha.text = "${fe!.day}/${fe.month}/${fe.year} ";
        _hora.text = _evento!.tiempos!.horaEntrada!;

        lista = await databaseServices.getInvitadosByEvento(_evento!.id!);
        setState(() {
          lista = lista;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    //if (isLoading) _bloquearPantalla(false);

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
        body: _form());
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 15, right: 20),
          children: [
            _title("Información de fiesta/evento"),
            _subtitle("Fecha de evento"),
            Row(
              children: [
                _fechaw(),
                _horaw(),
              ],
            ),
            _nombreField(),
            SizedBox(
              height: 30,
            ),
            isSaved ? _btnAgregarInvitado() : SizedBox(),
            SizedBox(
              height: 30,
            ),
            _listaInvitados(),
            SizedBox(
              height: 30,
            ),
            isSaved ? SizedBox() : _button(),
            SizedBox(
              height: 30,
            ),
          ],
        ));
  }

  _nombreField() {
    return Container(
        padding: EdgeInsets.only(left: 25, right: 20, top: 10),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {},
          readOnly: isSaved,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hoverColor: Colors.purple,
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Nombre del evento",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: _nombre,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  _subtitle(String texto) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          texto,
          style: TextStyle(
              color: Color.fromARGB(
                  255,
                  usuarioBloc.miFraccionamiento.color!.r,
                  usuarioBloc.miFraccionamiento.color!.g,
                  usuarioBloc.miFraccionamiento.color!.b),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ));
  }

  _fechaw() {
    return Container(
        width: w! * 0.35,
        margin: EdgeInsets.only(left: 25),
        //padding: EdgeInsets.only(left: 80, right: 80),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            isSaved ? null : _selectDate();
          },
          readOnly: true,
          decoration: InputDecoration(
            hoverColor: Colors.purple,
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Día",
            hintText: "dd/MM/yyyy",
            enabledBorder: border(false),
            focusedBorder: border(true),
            //enabledBorder: border(false),
            //focusedBorder: border(true),
            //border: border(false),
            errorText: null,
          ),
          controller: _fecha,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Widget _button() {
    print(usuarioBloc.perfil.nombre);
    return InkWell(
      onTap: () async {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);

        if (!_formKey.currentState!.validate()) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }
        try {
          setState(() {
            selectedDate = new DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, _fromTime.hour, _fromTime.minute);
          });
          print(_fromTime.toString());
          print(selectedDate.toString());

          _evento!.tipoVisita = TipoVisita.fiesta;
          _evento!.nombre = _nombre.text;
          _evento!.domicilio = usuarioBloc.perfil.direccion;
          _evento!.idResidente = usuarioBloc.perfil.idResidente;
          _evento!.nombreResidente = usuarioBloc.perfil.nombre;

          Evento.Tiempos tiempos = new Evento.Tiempos();

          tiempos.fechaEntrada = selectedDate;
          tiempos.horaEntrada = _hora.text;

          _evento!.tiempos = tiempos;

          late var bytes; // data being hashed
          bytes = utf8.encode(
              _evento!.nombre! + _evento!.tiempos!.fechaEntrada.toString());
          var digest = sha1.convert(bytes);
          _evento!.id = digest.toString();

          await db.guardarEvento(_evento!);
          setState(() {
            //_invitadosBloc.idvento = _evento!.id.toString();
            isSaved = true;
          });
        } catch (e) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        }

        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      },
      child: Container(
        width: w! - 200,
        margin: EdgeInsets.only(left: 30, right: 30),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(
              255,
              usuarioBloc.miFraccionamiento.color!.r,
              usuarioBloc.miFraccionamiento.color!.g,
              usuarioBloc.miFraccionamiento.color!.b),
          borderRadius: BorderRadius.all(
              Radius.circular(30.0) //         <--- border radius here
              ),
        ),
        child: Text(
          "Continuar",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: usuarioBloc.miFraccionamiento.getColor(), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: usuarioBloc.miFraccionamiento
                    .getColor(), // button text color
                foregroundColor:Colors.white
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _fecha.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
      });
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
      //initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: usuarioBloc.miFraccionamiento.getColor(), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: usuarioBloc.miFraccionamiento
                    .getColor(), // button text color
                foregroundColor:Colors.white
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
        String minute = _fromTime.minute < 10
            ? "0${_fromTime.minute}"
            : _fromTime.minute.toString();
        _hora.text = _fromTime.hour.toString() + ":" + minute;
      });
    }
  }

  _title(String text) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          text,
          style: TextStyle(
              color: Color.fromARGB(
                  255,
                  usuarioBloc.miFraccionamiento.color!.r,
                  usuarioBloc.miFraccionamiento.color!.g,
                  usuarioBloc.miFraccionamiento.color!.b),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ));
  }

  _horaw() {
    return Container(
      width: w! * 0.35,
      margin: EdgeInsets.only(left: 25),
      child: TextFormField(
        //enableInteractiveSelection: false,
        onTap: () {
          isSaved ? null : _showTimePicker();
        },
        readOnly: true,
        decoration: InputDecoration(
          //prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.white,
          labelText: "Hora",
          hintText: "hh:mm",
          enabledBorder: border(false),
          focusedBorder: border(true),
          border: border(false),
          errorText: null,
        ),
        controller: _hora,

        validator: (value) {
          if (value!.isEmpty) {
            return "Campo requerido";
          }
          return null;
        },
      ),
    );
  }

  _btnAgregarInvitado() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                //lista.add(Invitado());
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        DatosInvitado(_evento!.id!),
                  ),
                );
              });
            },
            child: Row(
              children: [
                Text("Agregar Invitado"),
                SizedBox(
                  width: 10,
                ),
                Icon(FontAwesomeIcons.plus)
              ],
            ),
          )
        ],
      ),
    );
  }

  _listaInvitados() {
    //lista = Provider.of<ListaInvitadosProvider>(context);
    print("lista " + lista.toString());
    return lista.length == 0
        ? SizedBox(
            height: 10,
          )
        : Container(
            margin: EdgeInsets.only(left: 25),
            child: ColumnBuilder(
                itemCount: lista.length,
                itemBuilder: (c, i) {
                  String? nombre = lista[i].nombre ?? "Invitado 1";
                  nombre = nombre.length > 20
                      ? lista[i].nombre!.substring(0, 20) + "..."
                      : lista[i].nombre;

                  return Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpandablePanel(
                        header: Text(
                          nombre ?? "Invitado ${i + 1}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        collapsed: SizedBox(),
                        expanded: _contenidoUsuario(i),
                      ),
                    ),
                  );
                }));
  }

  _contenidoUsuario(int i) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(children: [
        // DatosInvitado(i, _evento!.id.toString())
        SizedBox(
          height: 20,
        ),
        _field("Nombre", lista[i].nombre),
        _field(
            "Número de acompañantes", lista[i].acompanantes?.toString() ?? "0"),
        _opciones(i),
        SizedBox(
          height: 10,
        )
      ]),
    );
  }

  _opciones(i) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          lista[i].idEvento == null
              ? SizedBox()
              : Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () async {
                      String response;
                      Reference reference =
                          storage.ref().child("${lista[i].id}/qr");
                      response = await reference.getDownloadURL();

                      print(response);

                      final shortener = BitLyShortener(
                          accessToken:
                              "784ce10cf099581554f2c50169308aa659f7ed35");
                      final linkData =
                          await shortener.generateShortLink(longUrl: response);
                      String? urfinal = linkData.link;
                      print(linkData.link);
                      await Share.share(
                          "¡Hola!,este es el link para tu acceso para el evento ${_evento!.nombre}: ${urfinal!}");
                    },
                    icon: Icon(
                      FontAwesomeIcons.shareFromSquare,
                      color: Colors.grey[850],
                      size: 20,
                    ),
                  ),
                ),
          /*Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DatosInvitado(),
                  ),
                );*/
              },
              icon: Icon(
                FontAwesomeIcons.penToSquare,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),*/
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                _eliminarInvitado(i);
              },
              icon: Icon(
                FontAwesomeIcons.trash,
                color: Colors.red,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  _eliminarInvitado(int i) async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Eliminar'),
        content: new Text('¿Eliminar invitado?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Provider.of<LoadingProvider>(context, listen: false)
                  .setLoad(true);
              try {
                DatabaseServices databaseServices = new DatabaseServices();

                await databaseServices.borrarInvitado(lista[i].id.toString());

                setState(() {
                  lista.removeAt(i);
                });
              } catch (e) {
                print("No se pudo eliminar al invitado: " + e.toString());
                Fluttertoast.showToast(
                  msg: "No se pudo eliminar al invitado",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey[800],
                );
              }

              Provider.of<LoadingProvider>(context, listen: false)
                  .setLoad(false);
              Navigator.of(context).pop(false);
            },
            child: new Text('Sí'),
          ),
        ],
      ),
    );
  }

  _field(String label, String? texto) {
    return Container(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: "$label :  ",
          style: TextStyle(
              fontWeight: FontWeight.w300, color: Colors.black, fontSize: 17),
          children: <TextSpan>[
            TextSpan(
                text: texto,
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20))
          ],
        ),
      ),
    );
  }
}
