import 'dart:math';

import "package:apppagoplux/src/component/paybox.dart";
import 'package:apppagoplux/src/model/pagoplux_model.dart';
import 'package:apppagoplux/src/model/response_model.dart';
import 'package:apppagoplux/src/pages/history.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  PagoPluxModel? _paymentModelExample;
  String voucher = 'Pendiente Pago';

  String name = '';
  String email = '';
  String address = '';
  String id = '';
  String phone = '';
  double payvalue = 0.00;

//controllers para validaciones
  final _formfield = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final valueController = TextEditingController();

  var maskTelefono = MaskTextInputFormatter(
      mask: '### ### ####', filter: {'#': RegExp(r'[0-9]')});
  var maskId = MaskTextInputFormatter(
      mask: '##########', filter: {'#': RegExp(r'[0-9]')});

//Consulta http
  String url =
      'https://apipre.pagoplux.com/intv1/integrations/getTransactionsEstablishmentResource';
  String request_username = 'o3NXHGmfujN3Tyzp1cyCDu3xst';
  String request_password = 'TkBhZQP3zwMyx3JwC5HeFqzXM4p0jzsXp0hTbWRnI4riUtJT';

  @override
  Widget build(BuildContext context) {
    //openPpx();
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 70.0),
        children: <Widget>[
          Form(
            key: _formfield,
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Datos para el pago',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                SizedBox(
                  width: 300.0,
                  height: 15.0,
                  child: Divider(
                    color: Colors.blueGrey[600],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                _inputNombre(),
                const SizedBox(
                  height: 15,
                ),
                _inputEmail(),
                const SizedBox(
                  height: 15,
                ),
                _inputDireccion(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _inputIdentificacion(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.44,
                      child: _inputTelefono(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _inputValorPago(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_formfield.currentState!.validate()) {
                      openPpx();
                      print('formvalidado');
                      if (validarCedula(id)) {
                        print('Completado');
                        /*nameController.clear();
                      emailController.clear();
                      phoneController.clear();
                      addressController.clear();
                      idController.clear();
                      valueController.clear();*/
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ModalPagoPluxView(
                            pagoPluxModel: _paymentModelExample!,
                            onClose: obtenerDatos,
                          ),
                        );
                      } else {
                        print('Cedula no valida');
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                      child: Text(
                        'Realizar pago',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => History()));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                      child: Text(
                        'Ir al historial de cobros',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openPpx() {
    print('Se habre el botón de pagos');
    this._paymentModelExample = PagoPluxModel();
    this._paymentModelExample?.payboxRemail = 'ricardo@virtualcreate.net';
    this._paymentModelExample?.payboxSendmail = email;
    this._paymentModelExample?.payboxRename = 'PagoPlux Shop';
    this._paymentModelExample?.payboxBase0 = 0.0;
    this._paymentModelExample?.payboxBase12 = payvalue;
    this._paymentModelExample?.payboxDescription = 'Pago desde Flutter';
    this._paymentModelExample?.payboxProduction = false;
    this._paymentModelExample?.payboxDirection = address;
    this._paymentModelExample?.payboxSendname = name;
    this._paymentModelExample?.payboxClientPhone = phone;
    this._paymentModelExample?.payboxClientIdentification = id;
    this._paymentModelExample?.payboxEnvironment = 'sandbox';
  }

  Widget crearTop(BuildContext context) {
    return Container(height: 0);
  }

  obtenerDatos(PagoResponseModel datos) {
    this.voucher = 'Voucher: ' + datos.detail.token;
    setState(() {});
    print('LLego ' + datos.detail.token);
  }

  bool validarCedula(String cedula) {
    // Validación de la longitud de la cédula
    if (cedula.length != 10) {
      return false;
    }

    // Extracción de la provincia
    int provincia = int.parse(cedula.substring(0, 2));

    // Validación del rango de la provincia
    if (provincia < 1 || provincia > 24) {
      return false;
    }

    // Cálculo del dígito verificador
    int suma = 0;
    for (int i = 0; i < 9; i++) {
      int digito = int.parse(cedula[i]);
      if (i % 2 == 0) {
        digito *= 2;
        if (digito > 9) {
          digito -= 9;
        }
      }
      suma += digito;
    }

    int ultimoDigitoCalculado = (10 - (suma % 10)) % 10;
    int ultimoDigitoCedula = int.parse(cedula[9]);

    // Comparación del dígito verificador
    return ultimoDigitoCalculado == ultimoDigitoCedula;
  }

  ///////// inputs

  Container _inputNombre() {
    return Container(
      //Container Nombre
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: nameController,
        keyboardType: TextInputType.name,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Nombre',
          labelText: 'Nombre completo',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingrese el nombre';
          } else if (value.length <= 3) {
            return 'Ingrese un nombre válido';
          }
          bool nameValid = RegExp(r"^[a-zA-Z]").hasMatch(value);
          if (!nameValid) {
            return 'Ingrese un nombre válido';
          }
        },
        onChanged: (value) {
          name = value;
        },
      ),
    );
  }

  Container _inputTelefono() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: phoneController,
        inputFormatters: [maskTelefono],
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Teléfono',
          labelText: 'Nro teléfono',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingrese el teléfono';
          } else if (value.length <= 7) {
            return 'El número de teléfono debe tener al menos 7 caracteres';
          }
        },
        onChanged: (value) {
          phone = value;
        },
      ),
    );
  }

  Container _inputDireccion() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: addressController,
        keyboardType: TextInputType.streetAddress,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Dirección',
          labelText: 'Dirección',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingrese la dirección';
          } else if (value.length < 3) {
            return 'Ingrese una dirección válida';
          }
        },
        onChanged: (value) {
          address = value;
        },
      ),
    );
  }

  Container _inputEmail() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Email',
          labelText: 'Correo electrónico',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingrese un email';
          }
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value);
          if (!emailValid) {
            return 'Ingrese un email válido';
          }
        },
        onChanged: (value) {
          email = value;
        },
      ),
    );
  }

  Container _inputValorPago() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: valueController,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '0.00',
          labelText: 'Valor de pago',
        ),
        validator: (value) {
          if (value!.isEmpty || value == '.' || value == ',') {
            return 'Ingrese un valor válido';
          }
        },
        onChanged: (value) {
          final RegExp _validCharactersRegExp = RegExp(r'^[0-9,.]+$');
          final String text = value.replaceAll(',', '.');

          if (text.isEmpty) {
            payvalue = 0.0;
          } else if (!_validCharactersRegExp.hasMatch(text)) {
            payvalue = 0.0;

            valueController.text = text.substring(0, text.length - 1);
          } else {
            payvalue = double.tryParse(text) ?? 0.0;
          }
        },
      ),
    );
  }

  Container _inputIdentificacion() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: idController,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Identificación',
          labelText: 'Identificación',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingrese la identificación';
          } else if (!validarCedula(value)) {
            return 'Cédula no válida';
          }
        },
        onChanged: (value) {
          id = value;
        },
      ),
    );
  }
}
