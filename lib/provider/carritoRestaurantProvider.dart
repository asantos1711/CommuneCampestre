import 'package:flutter/material.dart';

import '../models/restaurante/platillosPedidos.dart';
import '../models/restaurante/responseMenuJson.dart';

class CarritoProvider with ChangeNotifier {
  List<PlatillosPedidos>? listaPlatillos = [];

  List<PlatillosPedidos>? get platillos => listaPlatillos;

  agregarPlatillo(Platillo platillo) {
    int result = listaPlatillos!.indexWhere((element) =>
        element.idplatillo.toString().contains(platillo.id.toString()));
    if (result == -1) {
      listaPlatillos!.add(PlatillosPedidos(
          idplatillo: platillo.id.toString(),
          cantidad: "1",
          nombre: platillo.nombre));
    } else {
      int cantidad = int.parse(listaPlatillos![result].cantidad.toString());
      cantidad++;
      listaPlatillos![result].cantidad = cantidad.toString();
    }
    notifyListeners();
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
    notifyListeners();
  }

  clean() {
    listaPlatillos = [];
    notifyListeners();
  }
}
