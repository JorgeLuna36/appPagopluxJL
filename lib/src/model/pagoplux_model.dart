/* ***************************************************************
 * @author      : Gerardo Yandún
 * @model        : PagoPluxModel
 * @description  : Componente modal que invoca a PagoPlux
 * @version  : v1.0.0
 * @copyright (c)  PagoPlux 2021
 *****************************************************************/
class PagoPluxModel {
  String? payboxRename;
  String? payboxSendname;
  String? payboxRemail;
  bool? payboxProduction;
  String? payboxSendmail;
  String? payboxEnvironment;
  String? payboxDescription;
  double? payboxBase0;
  double? payboxBase12;
  String? payboxCreditType;
  int? payboxNumInstallments;
  String? payboxInteres;
  int? payboxGraceMonths;
  String? payboxDirection;
  bool? payboxIntoDataPayment;
  String? payboxClientName;
  String? payboxClientPhone;
  String? payboxClientIdentification;
  bool? payboxRecurrent;
  String? payboxIdPlan;
  bool? payboxPermitirCalendarizar;
  bool? payboxPagoInmediato;
  bool? payboxCobroPrueba;

  PagoPluxModel({
    this.payboxRemail,
    this.payboxEnvironment,
    this.payboxProduction,
    this.payboxBase0,
    this.payboxBase12,
    this.payboxSendname,
    this.payboxSendmail,
    this.payboxRename,
    this.payboxDescription,
    this.payboxDirection,
    this.payboxInteres,
    this.payboxCreditType,
    this.payboxNumInstallments,
    this.payboxGraceMonths,
    this.payboxPagoInmediato,
    this.payboxPermitirCalendarizar,
    this.payboxIdPlan,
    this.payboxRecurrent,
    this.payboxIntoDataPayment,
    this.payboxClientIdentification,
    this.payboxClientPhone,
    this.payboxClientName,
    this.payboxCobroPrueba,
  });
}
