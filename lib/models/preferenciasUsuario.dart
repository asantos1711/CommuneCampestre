import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  PreferenciasUsuario._internal();
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();
  factory PreferenciasUsuario() => _instancia;

  late SharedPreferences _pref;

  initPref() async {
    _pref = await SharedPreferences.getInstance();
    /*if (_pref.getBool('isLoggedIn') ?? false) {
      await _pref.setBool('isFirstTime', false);
      await _pref.setString('mail', "");
      await _pref.setString('psw', "");
      await _pref.setBool('isLoggedIn', false);
    }*/
    return _pref;
  }

  String get email => _pref.getString('mail') ?? "";
  void setemail(String val) async => await _pref.setString('mail', val);

  String get keyStripe => _pref.getString('keyStripe') ?? "";
  void setkey(String val) async => await _pref.setString('keyStripe', val);

  String get psw => _pref.getString('psw') ?? "";
  Future<void> setpsw(String val) async => await _pref.setString('psw', val);

  String get lng => _pref.getString('lng') ?? "";
  Future<void> setlng(String val) async => await _pref.setString('lng', val);

  bool get isLoggedIn => _pref.getBool('isLoggedIn') ?? false;
  //set isLoggedIn(bool val) => _pref.setBool('isLoggedIn', val);
  void setisLoggedIn(bool val) async => await _pref.setBool('isLoggedIn', val);

  bool get isiniciarSesion => _pref.getBool('iniciarSesion') ?? false;
  //set isLoggedIn(bool val) => _pref.setBool('isLoggedIn', val);
  void setiniciarSesion(bool val) async =>
      await _pref.setBool('iniciarSesion', val);

  bool get isFirstTime => _pref.getBool('isFirstTime') ?? true;
  void setisFirstTime(bool val) async =>
      await _pref.setBool('isFirstTime', val);

  String get idFraccionamiento => _pref.getString('idFraccionamiento') ?? "";
  void setIdFraccionamiento(String val) async =>
      await _pref.setString('idFraccionamiento', val);
}
