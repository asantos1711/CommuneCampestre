import '../models/fraccionamientos.dart';
import '../models/invitadoModel.dart';
import '../models/usuarioModel.dart';

class UsuarioBloc {
  UsuarioBloc._internal();
  static final UsuarioBloc _singleton = new UsuarioBloc._internal();
  factory UsuarioBloc() => _singleton;

  Usuario perfil = new Usuario();
  List<Invitado>? listRecurrentes;

  String? qrInvitado;

  String? nombreTrabId;

  String? jwt;

  Invitado invitado = new Invitado();
  Fraccionamiento miFraccionamiento = new Fraccionamiento();

  String urlAut = "https://apimadrid.commune.com.mx/api/v1/security/login";
  String? jwtExpirationDate;

  bool deudor = false;
}
