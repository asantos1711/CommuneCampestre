import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
//import 'package:CommuneApp/config/translation.dart';
//import 'package:linkme/config/ui_helper.dart';

import '../bloc/usuario_bloc.dart';

class TextFormFieldBorder extends StatefulWidget {
  final String? hint;
  TextInputType? type = TextInputType.text;
  final TextEditingController? controller;
  Function? validation;
  Function? change;
  bool? obscure = false;
  Color? color;
  TextCapitalization? capitalization;
  Widget? prefixIcon;
  String? errorText;
  bool? space;
  double? paddingBoth;
  bool? readOnly;

  TextFormFieldBorder(this.hint, this.controller,
      {this.type,
      this.obscure,
      this.color,
      this.space,
      this.validation,
      this.paddingBoth,
      this.readOnly});
  TextFormFieldBorder.withCustomCapitalization(
      {this.errorText,
      this.change,
      this.hint,
      this.controller,
      this.type,
      this.obscure,
      this.color,
      this.capitalization,
      this.validation,
      this.space,
      this.prefixIcon,
      this.paddingBoth});
  TextFormFieldBorder.withCustomValidator(
      {this.hint,
      this.type,
      this.controller,
      this.validation,
      this.color,
      this.obscure,
      this.space,
      this.prefixIcon,
      this.paddingBoth});
  TextFormFieldBorder.withCustomChange(
      {this.hint,
      this.type,
      this.controller,
      this.change,
      this.space,
      this.prefixIcon,
      this.paddingBoth});
  TextFormFieldBorder.withCustomChangeAndValidator(
      {this.hint,
      this.type,
      this.controller,
      this.change,
      this.validation,
      this.color,
      this.space,
      this.prefixIcon,
      this.paddingBoth});

  @override
  _TextFormFieldBorderState createState() => _TextFormFieldBorderState();
}

class _TextFormFieldBorderState extends State<TextFormFieldBorder> {
  // UIHelper _uIHelper = new UIHelper();
  bool show = false;
  @override
  Widget build(BuildContext context) {
    widget.capitalization = (widget.type == TextInputType.emailAddress)
        ? TextCapitalization.none
        : widget.capitalization;
    this.widget.space = this.widget.space == null ? true : this.widget.space;
    return Padding(
        padding: EdgeInsets.only(
            left: this.widget.paddingBoth ?? 0,
            right: this.widget.paddingBoth ?? 0),
        child: Row(
          children: [
            this.widget.prefixIcon ?? SizedBox(),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                //enableInteractiveSelection: false,
                onTap: () {},
                textCapitalization: (widget.capitalization == null)
                    ? TextCapitalization.sentences
                    : widget.capitalization!,
                obscureText:
                    widget.obscure == null ? false : (widget.obscure! && !show),
                readOnly:
                    widget.readOnly != null ? (widget.readOnly as bool) : false,
                decoration: InputDecoration(
                  //prefixIcon: prefixIcon,
                  filled: true,
                  enabled: widget.readOnly != null
                      ? !(widget.readOnly as bool)
                      : true,
                  labelText: this.widget.hint,
                  fillColor: widget.color,
                  hintText: this.widget.hint,
                  enabledBorder: border(false),
                  focusedBorder: border(true),
                  border: border(false),
                  errorText: widget.errorText ?? null,
                ),

                controller: widget.controller,
                keyboardType: widget.type,
                inputFormatters: this.widget.space!
                    ? []
                    : [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                validator: widget.validation == null
                    // ignore: unnecessary_cast
                    ? (value) {
                        if (value.isEmpty) {
                          return "Campo requerido";
                          /*Translations.of(context)
                              .text("campo_requerido");*/
                        }
                        /*if (widget.type == TextInputType.emailAddress &&
                            !_uIHelper.isEmail(value)) {
                          return "Correo no valido";
                        //Translations.of(context).text("correo_no_valido");
                        }*/
                        return null;
                      } as String? Function(String?)?
                    : widget.validation as String? Function(String?)?,
                onChanged: (widget.change == null)
                    ? null
                    : widget.change as void Function(String)?,
              ),
            ),
            widget.obscure! ? _eye() : SizedBox(),
          ],
        ));
  }

  _eye() {
    return InkWell(
      onTap: () {
        setState(() {
          show = !show;
        });
      },
      child: show
          ? Icon(
              FontAwesome5Solid.eye,
              size: 20,
            )
          : Icon(
              FontAwesome5Solid.eye_slash,
              size: 20,
            ),
    );
  }
}

UnderlineInputBorder border(bool focus) {
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  return UnderlineInputBorder(
      //borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
          color: Color.fromARGB(
              255,
              usuarioBloc.miFraccionamiento.color!.r,
              usuarioBloc.miFraccionamiento.color!.g,
              usuarioBloc.miFraccionamiento.color!.b),
          width: focus ? 2 : 1));
}
