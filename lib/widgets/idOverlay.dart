import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';

class CameraOverlayCustom extends StatefulWidget {
  Function(File) func;
  CameraOverlayCustom({required this.func});
  @override
  _CameraOverlayCustomState createState() => _CameraOverlayCustomState();
}

class _CameraOverlayCustomState extends State<CameraOverlayCustom> {
  OverlayFormat format = OverlayFormat.cardID1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No camera found',
                    style: TextStyle(color: Colors.black),
                  ));
            }
            return CameraOverlay(snapshot.data!.first,
                CardOverlay.byFormat(OverlayFormat.cardID1), (XFile file) {
              this.widget.func(File(file.path));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              //image: FileImage(
              //   File(file.path),
              // ),
            },
                info:
                    'Coloque la identificación de manera que coincida con el rectángulo.',
                label: 'Capturado identificación');
          } else {
            return const Align(
                alignment: Alignment.center,
                child: Text(
                  'Fetching cameras',
                  style: TextStyle(color: Colors.black),
                ));
          }
        },
      ),
    );
  }
}
