import 'dart:math';
import 'package:redciclapp/src/utils/size_config.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';

import 'package:redciclapp/src/models/acopiador_model.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class RIKeys {
  static final riKey1 = const Key('__RIKEY1__');
  static final riKey2 = const Key('__RIKEY2__');
  static final riKey3 = const Key('__RIKEY3__');
  static final riKey4 = const Key('__RIKEY4__');
  static final riKey5 = const Key('__RIKEY5__');
  static final riKey6 = const Key('__RIKEY6__');
  static final riKey7 = const Key('__RIKEY7__');
  static final riKey8 = const Key('__RIKEY8__');
}

double _controlVertical = SizeConfig.devicePixelHeight;
double _controlHorizontal = SizeConfig.devicePixelWidth;
// bool _bigScreen = true;
// bool _smallScreen = false;
double _tamanoTexto = 20;
double _espacioEntreDatos = 10;
double _heightCajaSuperior = 300;
double _alturaComienzodelTexto = 50;
double _comienzoimagen = 100;

class VistaAcopiador extends StatefulWidget {
  @override
  _VistaAcopiadorState createState() => _VistaAcopiadorState();
}

ScreenshotController screenshotController = ScreenshotController();

class _VistaAcopiadorState extends State<VistaAcopiador> {
  Acopiador acopiador = new Acopiador();

  @override
  Widget build(BuildContext context) {
    final Acopiador recData = ModalRoute.of(context).settings.arguments;

    if (recData != null) {
      acopiador = recData;
    }

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'inicio'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          child: Icon(Icons.arrow_back_ios_outlined),
        ),
        body: Stack(
          children: <Widget>[
            _fondoApp(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _titulos(),
                  SizedBox(
                    height: _alturaComienzodelTexto,
                    width: 1,
                  ),
                  _datos(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _takeScreenshotandShare() async {
    File _imageFile;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      String fileName = DateTime.now().toIso8601String();
      File imgFile = new File('$directory/$fileName.png');
      imgFile.writeAsBytes(pngBytes);
      print("Captura guardada en la galeria");
      await Share.file('Anupam', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget _fondoApp() {
    print('RESOLUCION VERTICAL' + _controlVertical.toString());
    print('RESOLUCION HORIZONTAL' + _controlHorizontal.toString());
    if (_controlVertical < 1280) {
      _tamanoTexto = 18;
      _espacioEntreDatos = 10;
      _heightCajaSuperior = 250;
      _alturaComienzodelTexto = 50;
      _comienzoimagen = 170;
    } else {
      _tamanoTexto = 20;
      _espacioEntreDatos = 20;
      _heightCajaSuperior = 280;
      _alturaComienzodelTexto = 80;
      _comienzoimagen = 200;
    }

    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.5),
              end: FractionalOffset(0.0, 1.0),
              colors: [Colors.lightGreen[400], Colors.green])),
    );
    final cajaBlanca = Transform.rotate(
        angle: -pi / 6.0,
        child: Container(
            height: _heightCajaSuperior,
            width: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(85),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
              ),
            )));
    final cajaLogo = Transform.rotate(
        angle: -pi / 6.0,
        child: Stack(
          children: <Widget>[
            Container(
                height: 250.0,
                width: 350.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(85),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ),
                )),
            Positioned(
              top: 25.0,
              right: 10,
              child: Transform.rotate(
                angle: pi / 6,
                child: Image(
                  image: AssetImage('assets/logoclean.png'),
                  height: 60,
                ),
              ),
            )
          ],
        ));
    final imagen = Container(
        height: 200.0,
        width: 260.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(acopiador.fotourl), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(75),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
        ));
    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(top: -180.0, child: cajaBlanca),
        Positioned(bottom: -200.0, right: 130, child: cajaLogo),
        Positioned(top: _comienzoimagen, left: 200, child: imagen),
      ],
    );
  }

  Widget _titulos() {
    return SafeArea(
      child: Container(
          padding: EdgeInsets.only(left: 45),
          child: Column(
            children: <Widget>[
              Text(
                acopiador.nombre,
                style: TextStyle(
                    color: Color.fromRGBO(34, 181, 115, 1.0),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Centro de Acopio',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  Widget _datos() {
    return Table(
      children: [
        TableRow(key: RIKeys.riKey1, children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ciudad: ' + acopiador.ciudad,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _tamanoTexto,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: _espacioEntreDatos),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zona: ' + acopiador.zona,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _tamanoTexto,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ]),
        TableRow(key: RIKeys.riKey3, children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: _espacioEntreDatos),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dirección: ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _tamanoTexto,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  acopiador.direccion,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _tamanoTexto,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          )
        ]),
        TableRow(key: RIKeys.riKey4, children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: _espacioEntreDatos),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Qué residuos acopia?: ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _tamanoTexto,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  acopiador.querecibe,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _tamanoTexto,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          )
        ]),
        TableRow(key: RIKeys.riKey5, children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: _espacioEntreDatos),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zona',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _tamanoTexto,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  acopiador.zona,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _tamanoTexto,
                  ),
                ),
              ],
            ),
          ),
          _crearBoton(context),
        ]),
        TableRow(key: RIKeys.riKey6, children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: _espacioEntreDatos),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Horario de atención',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _tamanoTexto,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  acopiador.horarios,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          _compartir(context)
        ]),
        TableRow(key: RIKeys.riKey7, children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: _espacioEntreDatos),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _tamanoTexto,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  acopiador.detalles,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          _reportar(context),
        ]),
      ],
    );
  }

  Widget _crearBoton(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        RaisedButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.orange,
          textColor: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, 'pedidosaco', arguments: acopiador),
          icon: Icon(Icons.phone),
          label: Text('Contactar'),
        ),
      ],
    );
  }

  Widget _compartir(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        RaisedButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () async {
            _takeScreenshotandShare();
          },
          icon: Icon(Icons.share),
          label: Text('Compartir'),
        ),
      ],
    );
  }

  Widget _reportar(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        RaisedButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, 'denunciasaco',
              arguments: acopiador),
          icon: Icon(Icons.dangerous),
          label: Text('Reportar'),
        ),
      ],
    );
  }
}
