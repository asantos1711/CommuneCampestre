import 'package:campestre/models/restaurante/responseMenuJson.dart';

import '../models/restaurante/platillosPedidos.dart';

class CarritoBloc {
  CarritoBloc._internal();
  static final CarritoBloc _singleton = new CarritoBloc._internal();
  factory CarritoBloc() => _singleton;

  List<PlatillosPedidos>? listaPlatillos = [];

  List<PlatillosPedidos>? get platillos => listaPlatillos;

  PlatillosPedidos? getPlatillo(String idplatillo) {
    int result = listaPlatillos!.indexWhere((element) =>
        element.idplatillo.toString().contains(idplatillo.toString()));
    if (result == -1) {
      return null;
    } else {
      return listaPlatillos![result];
    }
  }

  addComentario(String comentario, String idplatillo) {
    int result = listaPlatillos!.indexWhere((element) =>
        element.idplatillo.toString().contains(idplatillo.toString()));

    listaPlatillos![result].extras = comentario.toString();
  }

  agregarPlatillo(Platillo platillo) {
    int result = listaPlatillos!.indexWhere((element) =>
        element.idplatillo.toString().contains(platillo.id.toString()));
    if (result == -1) {
      listaPlatillos!.add(PlatillosPedidos(
          idplatillo: platillo.id.toString(),
          cantidad: "1",
          tiempo: "1",
          comensal: "1",
          precio: platillo.precio,
          nombre: platillo.nombre));
    } else {
      int cantidad = int.parse(listaPlatillos![result].cantidad.toString());
      cantidad++;
      listaPlatillos![result].cantidad = cantidad.toString();
    }
  }

  restarPlatillo(Platillo platillo) {
    int result = listaPlatillos!.indexWhere((element) =>
        element.idplatillo.toString().contains(platillo.id.toString()));
    if (result == -1) {
      //No hace nada, por que , no hay platillo que eliminar,
      //y si entra , es por que el programador hizo mal s chamba jiijiji

    } else {
      int cantidad = int.parse(listaPlatillos![result].cantidad.toString());
      if (cantidad == 1) {
        listaPlatillos!.removeAt(result);
        return;
      } else {
        cantidad--;
        listaPlatillos![result].cantidad = cantidad.toString();
      }
    }
  }

  clean() {
    listaPlatillos = [];
  }
}
