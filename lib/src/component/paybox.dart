/* ***************************************************************
 * @author       : Gerardo Yandún
 * @model        : PagoPluxModel
 * @description  : Componente modal que presenta el botón de pagos
 * @version  : v1.0.0
 * @copyright (c)  PagoPlux 2021
 *****************************************************************/

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:apppagoplux/src/model/environment_model.dart';
import 'package:apppagoplux/src/model/pagoplux_model.dart';
import 'package:apppagoplux/src/model/response_model.dart';

/*
 * Componente View que presenta el modal con al webView de PagoPlux
 */
class ModalPagoPluxView extends StatelessWidget {
  final PagoPluxModel pagoPluxModel;
  final Function onClose;

  ModalPagoPluxView({required this.pagoPluxModel, required this.onClose});

  /*
   * Se construye la vista 
   */
  @override
  Widget build(BuildContext context) {
    // String url = this.getUrl(this.pagoPluxModel);
    String url = Uri.dataFromString(getHTML(this.pagoPluxModel),
            mimeType: 'text/html', encoding: Encoding.getByName('UTF-8'))
        .toString();

    Uri uri = Uri.dataFromString(getHTML(this.pagoPluxModel),
        mimeType: 'text/html', encoding: Encoding.getByName('UTF-8'));
    print(Uri.decodeFull(uri.toString()));
    return Material(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
                automaticallyImplyLeading: false,
                title: Text('PagoPlux', style: TextStyle(fontSize: 16)),
                backgroundColor: Color.fromARGB(250, 22, 155, 213),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.close_sharp),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
                centerTitle: false)),
        body: SafeArea(
            bottom: false,
            child: Container(
              padding: EdgeInsets.all(8),
              child: WebviewScaffold(
                url: url,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                    name: 'Print',
                    onMessageReceived: (JavascriptMessage message) {
                      print(message.message);
                      Map<String, dynamic> response =
                          jsonDecode(message.message);
                      PagoResponseModel responseModel =
                          PagoResponseModel.fromMap(response);
                      this.onClose(responseModel);
                      Navigator.of(context).pop();
                    },
                  )
                ].toSet()),
                mediaPlaybackRequiresUserGesture: false,
                withZoom: false,
                withLocalStorage: true,
                hidden: false,
                enableAppScheme: true,
                allowFileURLs: true,
                initialChild: Container(
                  color: Colors.white10,
                  child: const Center(
                    child: Text('Cargando....',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  /*
   * Se genera la URL para obtener la URL de pago
   * @param pagoPluxModel  Modelo PagoPlux 
   */
  String getUrl(PagoPluxModel pagoPluxModel) {
    String url = '';
    switch (pagoPluxModel.payboxEnvironment) {
      case 'product':
        url = Environments.product;
        break;
      case 'prod':
        url = Environments.prod;
        break;
      default:
        url = Environments.sandbox;
        break;
    }
    return url;
  }

  /*
   * Genera el HTML para enviar a PagoPlux
   */
  String getHTML(PagoPluxModel pagoPluxModel) {
    String html = '<html>';
    html += ' <body><form action="' + getUrl(pagoPluxModel) + '/movil.html">';
    html += '<input type="hidden" value="' +
        pagoPluxModel.payboxRemail! +
        '" name="PayboxRemail">';
    if (pagoPluxModel.payboxRename != null) {
      html += '<input type="hidden" value="' +
          Uri.encodeFull(pagoPluxModel.payboxRename!) +
          '" name="PayboxRename">';
    }
    if (pagoPluxModel.payboxSendmail != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxSendmail! +
          '" name="PayboxSendmail">';
    }
    if (pagoPluxModel.payboxSendname != null) {
      html += '<input type="hidden" value="' +
          Uri.encodeFull(pagoPluxModel.payboxSendname!) +
          '" name="PayboxSendname">';
    }
    if (pagoPluxModel.payboxDescription != null) {
      html += '<input type="hidden" value="' +
          Uri.encodeFull(pagoPluxModel.payboxDescription!) +
          '" name="PayboxDescription">';
    }
    if (pagoPluxModel.payboxBase0 != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxBase0.toString() +
          '" name="PayboxBase0">';
    }
    if (pagoPluxModel.payboxBase12 != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxBase12.toString() +
          '" name="PayboxBase12">';
    }
    if (pagoPluxModel.payboxEnvironment != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxEnvironment! +
          '" name="PayboxEnvironment">';
    }
    html += '<input type="hidden" value="' +
        pagoPluxModel.payboxProduction.toString() +
        '" name="PayboxProduction">';
    if (pagoPluxModel.payboxDirection != null) {
      html += '<input type="hidden" value="' +
          Uri.encodeFull(pagoPluxModel.payboxDirection!) +
          '" name="PayboxDirection">';
    }
    if (pagoPluxModel.payboxClientName != null) {
      html += '<input type="hidden" value="' +
          Uri.encodeFull(pagoPluxModel.payboxClientName!) +
          '" name="PayboxClientName">';
    }
    if (pagoPluxModel.payboxClientIdentification != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxClientIdentification! +
          '" name="PayboxClientIdentification">';
    }
    if (pagoPluxModel.payboxClientPhone != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxClientPhone! +
          '" name="PayboxClientPhone">';
    }
    if (pagoPluxModel.payboxCreditType != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxCreditType! +
          '" name="PayboxCreditType">';
    }
    if (pagoPluxModel.payboxInteres != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxInteres! +
          '" name="PayboxInteres">';
    }
    if (pagoPluxModel.payboxIdPlan != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxIdPlan! +
          '" name="PayboxIdPlan">';
    }
    if (pagoPluxModel.payboxCobroPrueba != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxCobroPrueba.toString() +
          '" name="PayboxCobroPrueba">';
    }
    if (pagoPluxModel.payboxGraceMonths != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxGraceMonths.toString() +
          '" name="PayboxGraceMonths">';
    }
    if (pagoPluxModel.payboxIntoDataPayment != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxIntoDataPayment.toString() +
          '" name="PayboxIntoDataPayment">';
    }
    if (pagoPluxModel.payboxNumInstallments != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxNumInstallments.toString() +
          '" name="PayboxNumInstallments">';
    }
    if (pagoPluxModel.payboxRecurrent != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxRecurrent.toString() +
          '" name="PayboxRecurrent">';
    }
    if (pagoPluxModel.payboxPermitirCalendarizar != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxPermitirCalendarizar.toString() +
          '" name="PayboxPermitirCalendarizar">';
    }
    if (pagoPluxModel.payboxPagoInmediato != null) {
      html += '<input type="hidden" value="' +
          pagoPluxModel.payboxPagoInmediato.toString() +
          '" name="PayboxPagoInmediato">';
    }

    html += '</form>';
    html += '<script>';
    html += 'document.forms[0].submit();';
    html += '</script>';
    html += '</body>';
    html += '</html>';
    return html;
  }
}
