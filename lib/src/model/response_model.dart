/* ***************************************************************
 * @author       : Gerardo Yandún
 * @model        : PagoResponseModel
 * @description  : Objeto de respuesta en pago
 * @version  : v1.0.0
 * @copyright (c)  PagoPlux 2021
 *****************************************************************/

//   PagoResponseModel.fromJsonMap(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//     status = json['status'];
//     detail = DetailModel.fromJsonMap(json['detail']);
//   }
// }

import 'dart:convert';

class PagoResponseModel {
  int code;
  String description;
  Detail detail;
  String status;

  PagoResponseModel({
    required this.code,
    required this.description,
    required this.detail,
    required this.status,
  });

  factory PagoResponseModel.fromJson(String str) =>
      PagoResponseModel.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  factory PagoResponseModel.fromMap(Map<String, dynamic> json) =>
      PagoResponseModel(
        code: json["code"],
        description: json["description"],
        detail: Detail.fromMap(json["detail"]),
        status: json["status"],
      );

  // Map<String, dynamic> toMap() => {
  //     "code": code,
  //     "description": description,
  //     "detail": detail.toMap(),
  //     "status": status,
  // };
}

//   DetailModel.fromJsonMap(Map<String, dynamic> json) {
//     token = json['token'];
//     amount = json['amount'];
//     cardType = json['cardType'];
//     cardInfo = json['cardInfo'];
//     cardIssuer = json['cardIssuer'];
//     clientID = json['clientID'];
//     clientName = json['clientName'];
//     fecha = json['fecha'];
//   }
// }
class Detail {
  String token;
  String amount;
  String cardType;
  String cardInfo;
  String cardIssuer;
  String clientId;
  String clientName;
  String fecha;

  Detail({
    required this.token,
    required this.amount,
    required this.cardType,
    required this.cardInfo,
    required this.cardIssuer,
    required this.clientId,
    required this.clientName,
    required this.fecha,
  });

  factory Detail.fromJson(String str) => Detail.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  factory Detail.fromMap(Map<String, dynamic> json) => Detail(
        token: json["token"],
        amount: json["amount"],
        cardType: json["cardType"],
        cardInfo: json["cardInfo"],
        cardIssuer: json["cardIssuer"],
        clientId: json["clientID"],
        clientName: json["clientName"],
        fecha: json["fecha"],
      );

  // Map<String, dynamic> toMap() => {
  //     "token": token,
  //     "amount": amount,
  //     "cardType": cardType,
  //     "cardInfo": cardInfo,
  //     "cardIssuer": cardIssuer,
  //     "clientID": clientId,
  //     "clientName": clientName,
  //     "fecha": fecha,
  // };
}
