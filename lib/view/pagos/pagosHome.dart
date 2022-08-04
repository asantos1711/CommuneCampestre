import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../bloc/usuario_bloc.dart';
import '../../controls/payment.dart';
import '../../models/estadoCuenta/detailEstadoCuenta.dart';
import '../../services/apiResidencial/estadoCuentaProvider.dart';
import '../login.dart';
import 'strippe.dart';

class PagosHome extends StatefulWidget {
  //const PagosHome({ Key? key }) : super(key: key);

  @override
  State<PagosHome> createState() => _PagosHomeState();
}

class _PagosHomeState extends State<PagosHome> {
  EstadoCuentaProvider _estadoCuentaProvider = new EstadoCuentaProvider();
  DetailEstadoCuenta _detailEstadoCuenta = new DetailEstadoCuenta();
  DetailEstadoCuenta _detailEstadoCuentaPag = new DetailEstadoCuenta();
  DetailEstadoCuenta _detailEstadoCuentaPorPag = new DetailEstadoCuenta();
  final PaymentController controller = Get.put(PaymentController());
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  int band = 0;
  double deudaTotal = 0;

  var pixelRatio;
  var logicalScreenSize;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pixelRatio = window.devicePixelRatio;
    logicalScreenSize = window.physicalSize / pixelRatio;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        // add tabBarTheme
        tabBarTheme: TabBarTheme(
            labelColor: Color(0xFFFFFFFF),
            labelStyle: TextStyle(
                color: _usuarioBloc.miFraccionamiento.getColor(),
                fontWeight: FontWeight.bold), // color for text
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    color: _usuarioBloc.miFraccionamiento.getColor()))),
        primaryColor: Colors.pink[800],
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "Pagos",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF06323D),
                  fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
            //actions: [_toPay()],
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(0xFF0C0C0C),
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Por pagar",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(
                          255,
                          _usuarioBloc.miFraccionamiento.color!.r,
                          _usuarioBloc.miFraccionamiento.color!.g,
                          _usuarioBloc.miFraccionamiento.color!.b),
                    ),
                  ),
                ),
                //Tab(child: Text("Vencidos", style: TextStyle(fontSize: 16, color: Color(0xFF5E1281)),),),
                Tab(
                  child: Text(
                    "Pagados",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(
                          255,
                          _usuarioBloc.miFraccionamiento.color!.r,
                          _usuarioBloc.miFraccionamiento.color!.g,
                          _usuarioBloc.miFraccionamiento.color!.b),
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Todos",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(
                          255,
                          _usuarioBloc.miFraccionamiento.color!.r,
                          _usuarioBloc.miFraccionamiento.color!.g,
                          _usuarioBloc.miFraccionamiento.color!.b),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _porPagar(),
              //_vencidos(),
              _pagados(),
              _todos()
            ],
          ),
        ),
      ),
    );
  }

  _porPagar() {
    return FutureBuilder(
      future: _estadoCuentaProvider.getDetailPorPagar(),
      builder: (BuildContext context, AsyncSnapshot sn) {
        if (sn.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset(
              "assets/icon/casita.gif",
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          );
        }
        _detailEstadoCuentaPorPag = sn.data;
        if (_detailEstadoCuentaPorPag.data.toString() == "[]" ||
            _detailEstadoCuentaPorPag.data.toString() == "null") {
          return Container(
            alignment: Alignment.center,
            child: Text(
              "No hay cargos pendientes de pago",
              style: TextStyle(
                  fontSize: 18,
                  color: _usuarioBloc.miFraccionamiento.getColor()),
            ),
          );
        } else {
          print(_detailEstadoCuentaPorPag.toJson());
          return Stack(
            children: [
              ListView.builder(
                itemCount: _detailEstadoCuentaPorPag.data?.length ?? 0,
                itemBuilder: (context, index) {
                  //return _contenido(DateFormat('dd/MM/yyyy').format(_mantenimientos.data!.mantenimientoList![index].payDate as DateTime), _mantenimientos.data!.mantenimientoList![index].status.toString().toCapitalized() , _mantenimientos.data!.mantenimientoList![index].amount.toString());

                  return _contenidoVencido(
                      _detailEstadoCuentaPorPag.data![index].descripcion
                          .toString()
                          .toCapitalized(),
                      _detailEstadoCuentaPorPag.data![index].cargo.toString(),
                      _detailEstadoCuentaPorPag.data![index].tipo.toString(),
                      _detailEstadoCuentaPorPag.data![index].identificador
                          .toString(),
                      _detailEstadoCuentaPorPag.data![index].estado.toString(),
                      _detailEstadoCuentaPorPag.data?[index].fechaCreado
                          as DateTime);
                },
              ),
              FutureBuilder(
                future:
                    controller.getDeuda(_usuarioBloc.perfil.lote.toString()),
                builder: (BuildContext context, AsyncSnapshot sn) {
                  if (!sn.hasData)
                    return Center(
                        child: Image.asset(
                      "assets/icon/casita.gif",
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ));
                  deudaTotal = sn.data;

                  if (deudaTotal > 0 &&
                      _usuarioBloc.miFraccionamiento.pagar == true) {
                    return SizedBox();
                    return Positioned(
                        bottom: 30,
                        left: 100,
                        child: InkWell(
                            onTap: () async {
                              Fluttertoast.showToast(
                                  msg: "Realizar su pago en la Administración",
                                  toastLength: Toast.LENGTH_LONG);
                              /*Provider.of<LoadingProvider>(context, listen: false)
                                .setLoad(true);
                            deudaTotal = await controller
                                .getDeuda(_usuarioBloc.perfil.lote.toString());
                            print(deudaTotal.toInt());
                            bool success = await controller.initPayment(
                                currency: "MXN",
                                amount: deudaTotal.toString(),
                                context: context);
                            if (success) {
                              await controller
                                  .saveMantto(
                                      _usuarioBloc.perfil.lote.toString(),
                                      deudaTotal)
                                  .whenComplete(() => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PagosHome()),
                                      ));
                            }
                            Provider.of<LoadingProvider>(context, listen: false)
                                .setLoad(false);*/
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Pagar mantenimientos",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255,
                                    _usuarioBloc.miFraccionamiento.color!.r,
                                    _usuarioBloc.miFraccionamiento.color!.g,
                                    _usuarioBloc.miFraccionamiento.color!.b),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        30) //                 <--- border radius here
                                    ),
                              ),
                            )));
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          );
        }
      },
    );
  }

  _todos() {
    return FutureBuilder(
      future: _estadoCuentaProvider.getDetail(),
      builder: (BuildContext context, AsyncSnapshot sn) {
        if (!sn.hasData)
          return Center(
              child: Image.asset(
            "assets/icon/casita.gif",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ));

        _detailEstadoCuenta = sn.data;

        return ListView.builder(
          itemCount: _detailEstadoCuenta.data?.length ?? 0,
          itemBuilder: (context, index) {
            //print(_usuarioBloc.deudor);

            //DateFormat('yyyy-MM-dd – kk:mm').format(now);
            //_detailEstadoCuenta.data![index].fecha.toString() _contenidoVencido

            if (_detailEstadoCuenta.data![index].estado == "pagado") {
              return _contenidoPagados(
                  _detailEstadoCuenta.data![index].descripcion
                      .toString()
                      .toCapitalized(),
                  _detailEstadoCuenta.data![index].cargo.toString());
            }

            if (_detailEstadoCuenta.data![index].estado != "pagado") {
              return _contenidoVencido(
                  _detailEstadoCuenta.data![index].descripcion
                      .toString()
                      .toCapitalized(),
                  _detailEstadoCuenta.data![index].cargo.toString(),
                  _detailEstadoCuenta.data![index].tipo.toString(),
                  _detailEstadoCuenta.data![index].identificador.toString(),
                  _detailEstadoCuenta.data![index].estado.toString(),
                  _detailEstadoCuenta.data![index].fecha as DateTime);
            } else {
              return SizedBox();
            }
          },
        );
      },
    );
  }

  _pagados() {
    return FutureBuilder(
      future: _estadoCuentaProvider.getDetailPagados(),
      builder: (BuildContext context, AsyncSnapshot sn) {
        if (!sn.hasData)
          return Center(
              child: Image.asset(
            "assets/icon/casita.gif",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ));

        _detailEstadoCuentaPag = sn.data;

        return ListView.builder(
          itemCount: _detailEstadoCuentaPag.data?.length ?? 0,
          itemBuilder: (context, index) {
            //DateFormat('yyyy-MM-dd – kk:mm').format(now);
            //_detailEstadoCuenta.data![index].fecha.toString() _contenidoVencido

            return _contenidoPagados(
                _detailEstadoCuentaPag.data![index].descripcion
                    .toString()
                    .toCapitalized(),
                _detailEstadoCuentaPag.data![index].cargo.toString());
          },
        );
      },
    );
  }

  _contenido(String titulo, String monto) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 5, right: 20, left: 20),
      child: Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text(titulo,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF313450),
                    fontWeight: FontWeight.w700))),
        Container(
          alignment: Alignment.centerLeft,
          child: Text("\$" + monto,
              style: TextStyle(fontSize: 14, color: Color(0xFF898A8F))),
        ),
        Divider()
      ]),
    );
  }

  _contenidoVencido(String titulo, String monto, String tipo, String id,
      String estado, DateTime fecha) {
    int count = 0;
    if (tipo.contains("mantenimiento") && estado.contains("vigente")) {
      count++;
    }

    return Container(
      width: w,
      margin: EdgeInsets.only(top: 20, bottom: 5, right: 20, left: 20),
      child: Column(children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: logicalScreenSize.width * 0.7,
                //w/1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pendiente",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(
                                  255,
                                  _usuarioBloc.miFraccionamiento.color!.r,
                                  _usuarioBloc.miFraccionamiento.color!.g,
                                  _usuarioBloc.miFraccionamiento.color!.b),
                              fontWeight: FontWeight.w600),
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(titulo,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF313450),
                                fontWeight: FontWeight.w700))),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("\$" + monto,
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF898A8F))),
                    ),
                  ],
                ),
              ),
              /*tipo.contains("sancion") &&
                      !estado.contains("pagado") &&
                      _usuarioBloc.miFraccionamiento.pagar == true
                  ? InkWell(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Realizar su pago en la Administración",
                            toastLength: Toast.LENGTH_LONG);
                        /*Provider.of<LoadingProvider>(context, listen: false)
                            .setLoad(true);
                        print(monto);
                        bool success = await controller.initPayment(
                            currency: "MXN",
                            amount: monto, 
                            context: context);
                        if (success) {
                          await controller.saveMulta(
                              _usuarioBloc.perfil.lote.toString(),
                              id,
                              int.parse(monto));
                          Provider.of<LoadingProvider>(context, listen: false)
                              .setLoad(false);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PagosHome()));
                        }
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoad(false);*/
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          child: Text("Pagar",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(
                                    255,
                                    _usuarioBloc.miFraccionamiento.color!.r,
                                    _usuarioBloc.miFraccionamiento.color!.g,
                                    _usuarioBloc.miFraccionamiento.color!.b),
                              ))),
                    )
                  : tipo.contains("cuota_extraordinaria") &&
                          !estado.contains("pagado") &&
                          _usuarioBloc.miFraccionamiento.pagar == true
                      ? InkWell(
                          onTap: () async {
                            Fluttertoast.showToast(
                                msg: "Realizar su pago en la Administración",
                                toastLength: Toast.LENGTH_LONG);
                            /*Provider.of<LoadingProvider>(context, listen: false)
                                .setLoad(true);
                            bool success = await controller.initPayment(
                                currency: "MXN",
                                amount: monto, 
                                context: context);
                            if (success) {
                              await controller.saveCuotaExtra(
                                  _usuarioBloc.perfil.lote.toString(),
                                  id,
                                  int.parse(monto));
                              Provider.of<LoadingProvider>(context,
                                      listen: true)
                                  .setLoad(false);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PagosHome()));
                            }
                            Provider.of<LoadingProvider>(context, listen: false)
                                .setLoad(false);*/
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Text("Pagar",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(
                                        255,
                                        _usuarioBloc.miFraccionamiento.color!.r,
                                        _usuarioBloc.miFraccionamiento.color!.g,
                                        _usuarioBloc
                                            .miFraccionamiento.color!.b),
                                  ))),
                        )
                      : tipo.contains("cuota") &&
                              !estado.contains("pagado") &&
                              _usuarioBloc.miFraccionamiento.pagar == true
                          ? InkWell(
                              onTap: () async {
                                Fluttertoast.showToast(
                                    msg:
                                        "Realizar su pago en la Administración",
                                    toastLength: Toast.LENGTH_LONG);
                                /*Provider.of<LoadingProvider>(context,
                                        listen: true)
                                    .setLoad(true);
                                bool success = await controller.initPayment(
                                    currency: "MXN",
                                    amount: monto,
                                    context: context);
                                if (success) {
                                  await controller.saveCuota(
                                      _usuarioBloc.perfil.lote.toString(),
                                      id,
                                      int.parse(monto));
                                  Provider.of<LoadingProvider>(context,
                                          listen: true)
                                      .setLoad(false);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PagosHome()));
                                }
                                Provider.of<LoadingProvider>(context,
                                        listen: true)
                                    .setLoad(false);*/
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text("Pagar",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(
                                            255,
                                            _usuarioBloc
                                                .miFraccionamiento.color!.r,
                                            _usuarioBloc
                                                .miFraccionamiento.color!.g,
                                            _usuarioBloc
                                                .miFraccionamiento.color!.b),
                                      ))),
                            )
                          : SizedBox()*/

              /*: tipo.contains("cuota") && !estado.contains("pagado")
                              ? InkWell(
                                  onTap: () async {
                                    //await Future.wait(waitList);
                                    //await controller.makePayment(amount: monto, currency: 'MXN', lote: _usuarioBloc.perfil.lote.toString(), idmulta: id).whenComplete(() async {
                                    await controller.saveCuota(
                                        _usuarioBloc.perfil.lote.toString(),
                                        id,
                                        int.parse(monto));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PagosHome()));
                                    //},);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text("Pagar",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255,
                                                _usuarioBloc
                                                    .miFraccionamiento.color!.r,
                                                _usuarioBloc
                                                    .miFraccionamiento.color!.g,
                                                _usuarioBloc
                                                    .miFraccionamiento.color!.b),
                                          ))),
                                )
                              : SizedBox(),*/
            ],
          ),
        ),
        Divider()
      ]),
    );
  }

  _contenidoPagados(String titulo, String monto) {
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 5, right: 20, left: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  /*Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fecha,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF898A8F)),
                      )),*/
                  Container(
                      alignment: Alignment.centerLeft,
                      width: logicalScreenSize.width * 0.7, //w - (w / 6),
                      child: Text(titulo,
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF313450),
                              fontWeight: FontWeight.w700))),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("\$" + monto,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF898A8F))),
                  ),
                ]),
                Container(
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesome.check_circle,
                    color: Color.fromARGB(
                        255,
                        _usuarioBloc.miFraccionamiento.color!.r,
                        _usuarioBloc.miFraccionamiento.color!.g,
                        _usuarioBloc.miFraccionamiento.color!.b),
                  ),
                )
              ],
            ),
            Divider()
          ],
        ));
  }

  _toPay() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) => const StrippePage(),
          ));
        },
        child: Text("Pagar"));
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
