import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../bloc/usuario_bloc.dart';
import '../models/pagos/manttoPorPagar.dart';
import '../models/pagos/pagosMultas.dart';
import '../services/jwt.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  Future<bool> initPayment(
      {required String currency,
      required String amount,
      required BuildContext context}) async {
    //Stripe.publishableKey = "";
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://us-central1-commune-cf48f.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'amount': calculateAmount(amount.toString()),
            'currency': currency,
            'payment_method_types[]': 'card'
          },
          headers: {
            'Authorization':
                'Bearer sk_test_51Jti97CudYnKG9fPr66RsW6527Mcaujs2z9RFlzELuBOLcwSkfSylQxvi9qbgrpWXjhvuFX8suAq2e8jI051bUEU00NHBlVzUA',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          testEnv: true,
          merchantCountryCode: 'MX', //MX
          merchantDisplayName:
              _usuarioBloc.miFraccionamiento.nombre, //Fraccionamiento
          customerId: jsonResponse?['customer'],
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          customerEphemeralKeySecret: jsonResponse?['ephemeralKey'],
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      //log("aqui");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment is successful'),
        ),
      );
      return true;
    } catch (errorr) {
      if (errorr is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${errorr.error.localizedMessage}',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ocurrio un error: $errorr'),
          ),
        );
      }

      return false;
    }
  }

  Future<void> makePayment(
      {required String amount, required String currency, required}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          testEnv: true,
          merchantCountryCode: 'US',
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData?['customer'],
          paymentIntentClientSecret: paymentIntentData?['client_secret'],
          customerEphemeralKeySecret: paymentIntentData?['ephemeralKey'],
        ));
        /*var response = await Stripe.instance.confirmPayment(
            paymentIntentData?['client_secret'],
            paymentIntentData as PaymentMethodParams);*/

        displayPaymentSheet();
        //saveMulta(lote, idmulta, int.parse(amount));
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      Stripe.instance.printInfo();

      Get.snackbar('Payment', 'Payment Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51KtDAZFYQVd0a0xFmAQRTLi65PdgZJydceq2tl5FCWzm40XgcFduioxBK1nHooAZ4DJUaR0MYfSnudGghv0kiQJa006HYloy4t',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  Future<PagosMultas> saveMulta(String usuario, String multa, int monto) async {
    String urlAPi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    JWTProvider jwtProvider = JWTProvider();
    PagosMultas model = new PagosMultas();
    String url = urlAPi + "api/v1/pagosmultas/save";
    String tk = await jwtProvider.getJWT();
    int deuda = 0;
    String token = "Bearer $tk"; //await _jwt.getJWT();
    DateTime _fechaHoy;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    /*final body = {
      "fechaInicial": "2021-01-01",
      "fechaFinal": "2022-12-31 23:59:59",
      "id": _usuarioBloc.perfil.lote,
      "variante": 0,
      "email": false
    };*/
    final body = {
      "id": multa,
      "loteTransient": {"id": usuario},
      "multaTransient": {"id": multa},
      "pagado": monto,
      "referencia": "Pago por Stripe",
      "metodoPago": {"id": 1},
      "caja": {"id": 1},
      "applyDescuento": 0,
      "autorizado": "",
      "noCuenta": "1234",
      "fecha_pago": formatted
    };

    /*print(body);
    print("--------avilabilityHotelsAPI----------");
    print(url);
    print(token);*/

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get availablility hotels at this time. Unexpected error:\n$e");
    }

    return model;
  }

  Future<PagosMultas> saveCuota(String usuario, String multa, int monto) async {
    String urlAPi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    JWTProvider jwtProvider = JWTProvider();
    PagosMultas model = new PagosMultas();
    String url = urlAPi + "api/v1/cuota/save";
    String tk = await jwtProvider.getJWT();
    String token = "Bearer $tk"; //await _jwt.getJWT();
    DateTime _fechaHoy;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    /*final body = {
      "fechaInicial": "2021-01-01",
      "fechaFinal": "2022-12-31 23:59:59",
      "id": _usuarioBloc.perfil.lote,
      "variante": 0,
      "email": false
    };*/
    final body = {
      "id": multa,
      "loteTransient": {"id": usuario},
      "multaTransient": {"id": multa},
      "pagado": monto,
      "referencia": "Pago por Stripe",
      "metodoPago": {"id": 1},
      "caja": {"id": 1},
      "applyDescuento": 0,
      "autorizado": "",
      "noCuenta": "1234",
      "fecha_pago": formatted
    };

    /*print(body);
    print("--------avilabilityHotelsAPI----------");
    print(url);
    print(token);*/

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    //print(response.body);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        /*if (decodeData["count"] == 0) {
          print("No hay hoteles disponibles");
          return model;
        }*/

        //print(decodeData);

        //print("Datos cargados");
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get availablility hotels at this time. Unexpected error:\n$e");
    }

    return model;
  }

  Future<PagosMultas> saveCuotaExtra(
      String usuario, String multa, int monto) async {
    print("EstadoCuenta*****");
    JWTProvider jwtProvider = JWTProvider();
    PagosMultas model = new PagosMultas();
    String urlAPi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    String url = urlAPi + "api/v1/pagocuotaextraordinaria/save";
    String tk = await jwtProvider.getJWT();
    String token = "Bearer $tk"; //await _jwt.getJWT();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final body = {
      "caja": {"id": 1},
      "cargoCuotaExtraordinaria": {"id": multa},
      "fechaPago": formatted,
      "id": usuario,
      "metodoPago": {"id": 1},
      "noCuenta": "1111",
      "pagado": monto,
      "referencia": "pagocuotaextraordinaria",
    };

    /*print(body);
    print("--------avilabilityHotelsAPI----------");
    print(url);
    print(token);*/

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    //print(response.body);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        /*if (decodeData["count"] == 0) {
          print("No hay hoteles disponibles");
          return model;
        }*/

        //print(decodeData);

        //print("Datos cargados");
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get availablility hotels at this time. Unexpected error:\n$e");
    }

    return model;
  }

  Future<PagosMultas> saveMantto(String usuario, double deuda) async {
    JWTProvider jwtProvider = JWTProvider();
    PagosMultas model = new PagosMultas();
    String urlAPi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    String url = urlAPi + "api/v1/cobromantenimiento/save";
    String tk = await jwtProvider.getJWT();
    //int deuda = 0;
    int cant = 0;
    int cantDesc = 0;
    String token = "Bearer $tk"; //await _jwt.getJWT();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedHoy = formatter.format(now);
    //String fechapago = fecha.year.toString() + "-"+ fecha.month.toString() + "-10";
    //String fechaformatted = formatter.format(fecha);

    ManttoPorPagar _mantosPendientes = await getManttos(usuario);

    List<Map<String, String>> _fechasList = [];

    var _intereses = [];

    _mantosPendientes.data?.interesesMoratoriosList?.forEach((element) {
      cantDesc = cantDesc + (element.montoDcto?.toInt() ?? 0);
      cant++;
      _intereses.add(element.toJson());
    });

    //print(_intereses);

    //= _mantosPendientes.data?.interesesMoratoriosList as List<InteresesMoratoriosList>;
    String val = "";

    _mantosPendientes.data?.mantenimientos?.forEach((element) {
      String val = formatter.format(element.fechaCorte as DateTime);
      Map<String, String> _mapa = {'date': val};

      //val = "{date: ${fc}}";s

      _fechasList.add(_mapa);
    });

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final body = {
      "id": usuario,
      "monto": deuda.toInt(),
      "range": _fechasList,
      "useFondo": false,
      "referencia": "Pago de app  Stripe",
      "metodoPago": {"id": 1},
      "caja": {"id": 1},
      "apply_descuento": 0,
      "autorizacion": "",
      "cantMoratorios": cant,
      "fechaPagoReal": formattedHoy,
      "interesesMoratoriosList": _intereses,
      "intereses_moratorios": null,
      "intereses_moratorios_dcto": cantDesc,
      "noCuenta": "1111",
      "payMoratorio": false,
    };

    /*print(body);
    print("--------avilabilityHotelsAPI----------");
    print(url);*/
    //print(token);

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    //print(response.body);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        /*if (decodeData["count"] == 0) {
          print("No hay hoteles disponibles");
          return model;
        }*/

        //print(decodeData);

        //print("Datos cargados");
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get availablility hotels at this time. Unexpected error:\n$e");
    }

    return model;
  }

  Future<double> getDeuda(String lote) async {
    JWTProvider jwtProvider = JWTProvider();
    ManttoPorPagar model = new ManttoPorPagar();
    String urlAPi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    String url = urlAPi + "api/v1/lote/get-for-pagarmantenimiento/" + lote;
    String tk = await jwtProvider.getJWT();
    double deuda = 0;
    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        model = ManttoPorPagar.fromJson(decodeData);
        deuda = model.data?.direccion?.deuda?.toDouble() ?? 0.0;

        if (model.data?.discount != null) {
          deuda = ((deuda * (model.data?.discount ?? 0.0) / 100));
        }

        deuda = (deuda + (model.data?.direccion?.deudaMoratorio?.toInt() ?? 0));
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get availablility hotels at this time. Unexpected error:\n$e");
    }

    return deuda;
  }

  Future<ManttoPorPagar> getManttos(String lote) async {
    JWTProvider jwtProvider = JWTProvider();
    ManttoPorPagar model = new ManttoPorPagar();
    String urlAPi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    String url = urlAPi + "api/v1/lote/get-for-pagarmantenimiento/" + lote;
    String tk = await jwtProvider.getJWT();
    double deuda = 0;
    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        model = ManttoPorPagar.fromJson(decodeData);
        deuda = model.data?.direccion?.deuda?.toDouble() ?? 0.0;

        if (model.data?.discount != null) {
          deuda = ((deuda * (model.data?.discount ?? 0.0) / 100));
        }

        deuda = (deuda + (model.data?.direccion?.deudaMoratorio?.toInt() ?? 0));
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get availablility hotels at this time. Unexpected error:\n$e");
    }

    return model;
  }
}
