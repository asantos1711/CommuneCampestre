import 'package:flutter/material.dart';

AppBar appBarOnlyPop(BuildContext context, double w) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    leadingWidth: w / 2,
    leading: InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          Text("Atrás", //Translations.of(context).text("bt_atras"),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ))
        ],
      ),
    ),
  );
}
