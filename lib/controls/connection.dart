import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campestre/models/eventoModel.dart';
import 'package:campestre/models/fraccionamientos.dart';
import 'package:campestre/models/invitadoModel.dart';
import 'package:campestre/models/preguntasModel.dart';
import 'package:campestre/models/reporteModel.dart';
import 'package:campestre/models/usuarioModel.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:campestre/bloc/usuario_bloc.dart';

class DatabaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  UsuarioBloc usuarioBloc = new UsuarioBloc();

  Future getProfile(String id) async {
    DocumentSnapshot snap = await db.collection('residente').doc("hast").get();
    if (snap.exists) {
      print(snap.data);
      //return Profile.fromFirestore(snap);
    }
    //return null;
  }

  Future<Usuario?> getProfileResidente(String? id) async {
    Usuario? usuario;
    try {
      DocumentSnapshot snap = await db.collection('usuarios').doc(id).get();
      print(snap.data());
      if (snap.exists) {
        print(snap.data);
        usuario = Usuario.fromMap(snap.data() as Map);
        return usuario;
      }
    } catch (e) {
      print("Error en la toma de datos : " + e.toString());
    }
    return usuario;
  }

  Future<List<Usuario>> getUsuarios(String email) async {
    List<Usuario> users = [];
    List<Usuario> lista = [];

    QuerySnapshot<Map<String, dynamic>> snap =
        await db.collection('usuarios').get();

    snap.docs.forEach((element) {
      print(element["lote"]);
      lista.add(Usuario.fromFirestore(element));
    });

    //print(lista);

    users = lista
        .where((element) => email.contains(element.email.toString()))
        .toList();
    //print(user);

    return users;
  }

  Future<Usuario> getUsuario(String email) async {
    Usuario user = new Usuario();
    List<Usuario> lista = [];
    print(_auth.currentUser!.uid);
    //print(db.);
    QuerySnapshot<Map<String, dynamic>> snap =
        await db.collection('usuarios').get();

    snap.docs.forEach((element) {
      lista.add(Usuario.fromFirestore(element));
    });

    //print(lista);

    user = lista
        .where((element) => email.contains(element.email.toString()))
        .first;
    //print(user);

    return user;
  }

  Future<List<Usuario>> getUsuarioByTitular() async {
    Usuario user = new Usuario();
    List<Usuario> lista = [];

    QuerySnapshot<Map<String, dynamic>> snap =
        await db.collection('usuarios').get();

    snap.docs.forEach((element) {
      user = Usuario.fromFirestore(element);

      if (user.idTitular == usuarioBloc.perfil.idResidente) {
        print(user.idTitular);
        print(usuarioBloc.perfil.idResidente);
        lista.add(user);
      }
    });

    return lista;
  }

  Future<List<Invitado>?> getRecurrentes(String id) async {
    List<Invitado> lista = [];

    /*DocumentSnapshot snaps =
        await db.collection('recurrentes').doc(id).get();

    if (snaps.exists) {
      Map<String, dynamic> map = snaps.data['recurrentes'];

      print("mapa " + map.toString());
      map.forEach((key, value) {
        lista.add(Invitado.fromMapRecurrente(value));
      });

      print(lista.toString());
      return lista;
    }*/

    return lista;
  }

  Future<List<Fraccionamiento>?> getFracionamientos() async {
    List<Fraccionamiento> lista = [];

    QuerySnapshot<Map<String, dynamic>> snaps =
        await db.collection('fraccionamientos').get();

    if (snaps.size != null) {
      snaps.docs.forEach((element) {
        print(element);
        lista.add(Fraccionamiento.fromJson(element.data()));
      });
    }

    print(lista);
    return lista;
  }

  Future<List<Usuario>> getUsuariosAdmin() async {
    List<Usuario> lista = [];

    QuerySnapshot<Map<String, dynamic>> snap =
        await db.collection('usuarios').get();

    snap.docs.forEach((element) {
      lista.add(Usuario.fromFirestore(element));
    });

    print(lista);

    lista = lista
        .where((element) => ("admin".contains(element.estatus.toString())))
        .toList();
    print(lista);

    return lista;
  }

  getFraccionamientoId(String id) async {
    //var snap = _databaseServices.getFracionamientosById(usuario.idFraccionamiento);

    Fraccionamiento _fracc = new Fraccionamiento();

    if (id == "") {
      print("Double tap");
      return;
    }

    DocumentSnapshot snaps =
        await db.collection('fraccionamientos').doc(id).get();
    print(snaps.data());

    if (snaps.exists) {
      print("dentro");
      Map<String, dynamic> mapa = snaps.data() as Map<String, dynamic>;
      _fracc = Fraccionamiento.fromJson(mapa);
      usuarioBloc.miFraccionamiento = _fracc;
    }

    //print(usuarioBloc.miFraccionamiento.color?.r);
  }

  static getFraccionamiento() async {
    final String _url =
        'https://communecampestre-default-rtdb.firebaseio.com/configuracion/fraccionamiento.json';

    Fraccionamiento fraccionamiento;
    UsuarioBloc _usuarioBloc = new UsuarioBloc();

    try {
      final response = await http.get(Uri.parse(_url));
      final decodedData = jsonDecode(response.body);
      //print("CONFIGURACIÓN " + decodedData.toString());
      fraccionamiento = Fraccionamiento.fromJson(decodedData);

      _usuarioBloc.miFraccionamiento = fraccionamiento;
    } on TimeoutException catch (exception) {
      print(
          'Error al cargar la configuracion. Tiempo de espera exedido: ${exception.message}');
    } catch (exception) {
      print("Erro inesperado al cargar la configuración: $exception");
    }

    return;
  }

  Future<Fraccionamiento> getFracionamientosById(String id) async {
    List<Fraccionamiento> lista = [];
    Fraccionamiento _fracc = new Fraccionamiento();

    DocumentSnapshot snaps =
        await db.collection('fraccionamientos').doc(id).get();

    if (snaps.exists) {
      Map<String, dynamic> mapa = snaps.data as Map<String, dynamic>;
      _fracc = Fraccionamiento.fromJson(mapa);
    }

    return _fracc;
  }

  Future<List<PreguntasFrecuentes>?> getPreguntas() async {
    List<PreguntasFrecuentes> lista = [];
    PreguntasFrecuentes _preg = new PreguntasFrecuentes();

    QuerySnapshot<Map<String, dynamic>> snaps =
        await db.collection('preguntas').get();

    if (snaps.size != null) {
      snaps.docs.forEach((element) {
        _preg = PreguntasFrecuentes.fromFirestore(element);
        if (usuarioBloc.miFraccionamiento.id == _preg.idFraccionamiento) {
          lista.add(_preg);
        }
      });
    }

    return lista;
  }

  Future<List<Invitado>?> getVisitasActivas() async {
    List<Invitado> lista = [];

    QuerySnapshot<Map<String, dynamic>> snaps =
        await db.collection('invitados').get();

    //snaps.where((user) => user.activo== true).toList();

    if (snaps.size != null) {
      snaps.docs.forEach((element) {
        Invitado _invitado = Invitado.fromMap(element);
        if (_invitado.idResidente!
            .contains(usuarioBloc.perfil.idResidente.toString())) {
          lista.add(_invitado);
        }
      });
    }

    await Future.forEach(lista, (element) async {
      element = element as Invitado;
      DateTime salida = element.tiempos?.fechaSalida ?? DateTime.now();
      if (DateTime.now().isAfter(salida)) {
        element.activo = false;
        await guardarDatos(element);
      }
    });

    List<Invitado> listanueva = [];
    Iterable<Invitado> listaInactivo = [];

    listanueva = lista.where((user) => user.activo == true).toList();
    listaInactivo = lista.where((user) => user.activo == false);
    lista = [];
    listanueva.addAll(listaInactivo);

    return listanueva;
  }

  Future<bool> desactivarQRs(Invitado _invitado) async {
    bool exito = false;

    try {
      await db
          .collection('invitados')
          .doc("${_invitado.id}")
          .set(_invitado.toJson());
      exito = true;
    } catch (ex) {
      exito = false;
      print(ex);
    }
    return exito;
  }

  Future<bool> desactivarUsuario(Usuario usuario) async {
    bool exito = false;

    try {
      await db
          .collection('usuarios')
          .doc("${usuario.idResidente}")
          .set(usuario.toJson());
      exito = true;
    } catch (ex) {
      exito = false;
      print(ex);
    }
    return exito;
  }

  Future addRecurrente(String id, Invitado? invitado) async {
    List<Invitado?>? currentList = usuarioBloc.listRecurrentes;
    print("currentList " + currentList.toString());
    if (currentList == null) {
      currentList = [];
    }

    currentList.add(invitado);

    Map<String, dynamic> map = new Map<String, dynamic>();
    //int i = 0;
    currentList.forEach((element) {
      var bytes = utf8.encode(element!.nombre!); // data being hashed

      var digest = sha1.convert(bytes);

      map[digest.toString()] = element.toJsonRecurrente();
    });

    /*try {
      await db
          .collection('recurrentes')
          .doc(id)
          .set({"recurrentes": map});
      //print("profile.id " + profile.id);

      List<Invitado> lista = [];

      DocumentSnapshot snaps =
          await db.collection('recurrentes').doc(id).get();

      Map<String, dynamic> mapa = snaps.data;   //[''];

      print("mapa " + mapa.toString());
      mapa.forEach((key, value) {
        lista.add(Invitado.fromMapRecurrente(value));
      });

      usuarioBloc.listRecurrentes = lista;

      print("Listo");
    } catch (e) {
      print("error $e");
    }*/
    /*await db.collection('recurrentes').document(id).get();
    if (snap.exists) {
      print(snap.data);
      //return Profile.fromFirestore(snap);
    }
    //return null;*/
  }

  Future<UserCredential> registerUser(String correo, String contra) async {
    Map<String, bool> map = Map<String, bool>();
    UserCredential result;

    result = await _auth.createUserWithEmailAndPassword(
        email: correo, password: contra);

    print("result: " + result.toString());
    //User? user = result.user;
    //print("result: " + user.toString());

    return result;
  }

  Future guardarDatosRegistro(Usuario usuario) async {
    try {
      await db
          .collection('usuarios')
          .doc("${usuario.idResidente}")
          .set(usuario.toJson());
      //print("profile.id " + profile.id);

      print("Listo");
    } catch (e) {
      print(e);
    }
    return;
  }

  Future updateUsuario(Usuario usuario) async {
    print(usuario.toJson());
    var bytes = utf8.encode(usuario.nombre!); // data being hashed

    //var digest = sha1.convert(bytes);
    //usuario.idResidente = digest.toString();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    //print("Digest as bytes: ${digest.bytes}");
    //print("Digest as hex string: $digest");
    //usuarioBloc.qrInvitado = digest.toString();
    try {
      await db
          .collection('usuarios')
          .doc("${usuario.idResidente}")
          .update(usuario.toJson());
      //print("profile.id " + profile.id);

      print("Listo");
    } catch (e) {
      print(e);
    }
    return;
  }

  Future guardarDatos(Invitado profile) async {
    //print("esta en el guardado");
    //print(profile.toJson());

    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      //print("Digest as bytes: ${digest.bytes}");
      //print("Digest as hex string: $digest");
      usuarioBloc.qrInvitado = profile.id;

      usuarioBloc.invitado = profile;

      await db
          .collection('invitados')
          .doc("${profile.id}")
          .set(profile.toJson());
      //print("profile.id " + profile.id);

      //print("Listo");
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<List<Invitado>> getRegistroInvitadoByNombre(String nombre) async {
    List<Invitado> lista = [];

    QuerySnapshot<Map<String, dynamic>> snaps =
        await db.collection('invitados').get();

    //snaps.where((user) => user.activo== true).toList();

    if (snaps.size != null) {
      snaps.docs.forEach((element) {
        Invitado _invitado = Invitado.fromMap(element);
        if (_invitado.nombre!.contains(nombre.toString())) {
          lista.add(_invitado);
        }
      });
    }

    lista.forEach((element) {
      print(element.nombre);
      print(element.tiempos);
    });

    print("LISTA - " + lista.toString());

    return lista;
  }

  Future borrarInvitado(String idInvitado) async {
    print("esta en el borrado");
    //print(profile.toJson());

    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection('invitados').doc("$idInvitado").delete();
      //print("profile.id " + profile.id);

      print("Listo");
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<EventoModel?> getEvento(String idEvento) async {
    EventoModel? evento;
    print("esta en el get de evento");
    //print(profile.toJson());

    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;

      final event = await db.collection('eventos').doc("$idEvento").get();
      if (event != null) {
        evento = EventoModel.fromMap(event.data()!);
      }
      print("Listo");
    } catch (e) {
      print("Error en " + e.toString());
    }
    return evento;
  }

  Future guardarEvento(EventoModel evento) async {
    //print("esta en el guardado de evento");
    //print(profile.toJson());

    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;

      /*usuarioBloc.qrInvitado = evento.id;

      usuarioBloc.invitado = evento;*/

      await db.collection('eventos').doc("${evento.id}").set(evento.toJson());

      print("Listo");
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<List<Invitado>> getInvitadosByEvento(String idEvento) async {
    List<Invitado> lista = [];
    EventoModel? evento;
    print("esta en el get de evento");
    //print(profile.toJson());

    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;

      final event = await db.collection('invitados').get();
      print("idEvento " + idEvento);
      event.docs.forEach((element) {
        lista.add(Invitado.fromMap(element));
      });

      Iterable<Invitado> listasub = lista.where((element) =>
          (element.idEvento != null) && (idEvento == element.idEvento));
      lista = [];
      listasub.forEach(
        (element) {
          lista.add(element);

          print(element.id);
          print(element.idEvento);
        },
      );

      print("Listo");
    } catch (e) {
      print("Error en " + e.toString());
    }
    return lista;
  }

  Future guardarReporte(Reporte reporte) async {
    //print("esta en el guardado");
    //print(profile.toJson());

    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      await db
          .collection('reportes')
          .doc("${reporte.id}")
          .set(reporte.toJson());
      //print("profile.id " + profile.id);

      print("Listo");
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<String> uploadFilee(File file, String name, String folder) async {
    String response = "";
    try {
      Reference reference = storage.ref().child("$folder/$name");
      Uint8List uint8list = await file.readAsBytes();
      UploadTask uploadTask = reference.putFile(file);
      response = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      print("URLFILE: $response");
    } catch (e) {
      print("Error uploadFilee " + e.toString());
    }
    return response;
  }
}
