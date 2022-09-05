import 'package:firebase_messaging_platform_interface/src/remote_notification.dart';
import 'package:flutter/material.dart';

class NotificacionView extends StatefulWidget {
  RemoteNotification? notification;
  NotificacionView({this.notification});

  @override
  State<NotificacionView> createState() => _NotificacionViewState();
}

class _NotificacionViewState extends State<NotificacionView> {
  RemoteNotification? notification;
  @override
  void initState() {
    // TODO: implement initState
    notification = this.widget.notification;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text(notification!.title.toString()),
            ),
            Container(
              child: Text(notification!.body.toString()),
            )
          ],
        ),
      ),
    );
  }
}
