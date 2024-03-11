import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String idEstablishment = '';
  String initialDate = '';
  String finalDate = '';
  String paymentType = 'unico';
  String status = 'pagado';
  String idClient = '';
  DateTime selectedInitialDate = DateTime.now();
  DateTime selectedFinalDate = DateTime.now();

  List<String> paymentOptions = ['unico', 'recurrente'];
  String selectedPayment = 'unico';
  List<String> statusOptions = [
    'pagado',
    'pendiente',
    'solicitado',
    'rechazado',
    'anulado',
    'fallido',
    'abierto'
  ];
  String selectedStatus = 'pagado';

  final _formfield = GlobalKey<FormState>();
  final idEstablishmentController = TextEditingController();
  final initialDateController = TextEditingController();
  final finalDateController = TextEditingController();
  final payTypeController = TextEditingController();
  final statusController = TextEditingController();
  final idClientController = TextEditingController();

  //Consulta
  String url =
      'https://apipre.pagoplux.com/intv1/integrations/getTransactionsEstablishmentResource';
  String request_username = 'o3NXHGmfujN3Tyzp1cyCDu3xst';
  String request_password = 'TkBhZQP3zwMyx3JwC5HeFqzXM4p0jzsXp0hTbWRnI4riUtJT';
  @override
  Widget build(BuildContext context) {
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
                    'Historial de cobros',
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
                _inputIdEstablecimiento(),
                const SizedBox(
                  height: 15,
                ),
                _inputIdCliente(),
                const SizedBox(
                  height: 15,
                ),
                const Text('Tipo de pago:'),
                _inputTipoPago(),
                const SizedBox(
                  height: 15,
                ),
                const Text('Rango de fechas:'),
                _inputFechas(),
                const SizedBox(
                  height: 15,
                ),
                const Text('Estado de la transacción:'),
                _inputEstado(),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    if (_formfield.currentState!.validate()) {
                      if (validarCedula(idClient)) {
                        print(idEstablishment);
                        print(idClient);
                        print(paymentType);
                        print(initialDate);
                        print(finalDate);
                        print(status);
                        await realizarConsulta();
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
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                      child: Text(
                        'Historial',
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

  Future<void> realizarConsulta() async {
    print('DENTRO CONSULTA');
    DateTime now = DateTime.now();
    String DateString = "${now.year}-${now.month}-${now.day}";

    final Map<String, String> body = {
      "numeroIdentificacion": "$idEstablishment",
      "initialDate": "$initialDate",
      "finalDate": "$finalDate",
      "tipoPago": "$paymentType",
      "estado": "$status",
      "identificacionCliente": "$idClient",
    };
    /*final Map<String, String> body = {
      "numeroIdentificacion": "1792039010001",
      "initialDate": "2024-01-01",
      "finalDate": "2024-03-10",
      "tipoPago": "unico",
      "estado": "pagado",
      "identificacionCliente": "1003145271"
    };*/
    print(body);

    String jsonBody = json.encode(body); //body a json

    var headers = {
      'Authorization': 'Basic ' +
          base64.encode(utf8.encode('$request_username:$request_password')),
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse(url),
        headers: headers, body: jsonBody); //solicitud

    if (response.statusCode == 200) {
      var data = json.decode(response.body); //respuesta a json
      mostrarRespuesta(data);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void mostrarRespuesta(Map<String, dynamic> data) {
    print('DENTRO MOSTRAR');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        title: Text('Historial de cobros'),
        content: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Descripción')),
              DataColumn(label: Text('Monto')),
            ],
            rows: [
              for (var transaction in data['detail']['transactionsData'])
                DataRow(cells: [
                  DataCell(Text(
                    transaction['fecha_transaccion'],
                    style: TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    transaction['descripcion'],
                    style: TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    transaction['monto'],
                    style: TextStyle(fontSize: 12),
                  )),
                ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
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

  Container _inputIdEstablecimiento() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: idEstablishmentController,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Establecimiento',
          labelText: 'Identificación del establecimiento',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingrese la identificación del establecimiento';
          } else if (value.length != 13) {
            return 'Ingrese un RUC válido';
          }
        },
        onChanged: (value) {
          idEstablishment = value;
        },
      ),
    );
  }

  Container _inputFechas() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            selectedInitialDate != null && selectedFinalDate != null
                ? '${selectedInitialDate.toString().split(' ').first} a ${selectedFinalDate.toString().split(' ').first}'
                : 'Fecha inicial',
            style: const TextStyle(fontSize: 20),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final pickedDate = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2010, 1),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedInitialDate = pickedDate.start;
                  selectedFinalDate = pickedDate.end;
                  initialDate = formattedDate(selectedInitialDate);
                  finalDate = formattedDate(selectedFinalDate);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  String formattedDate(DateTime dateTime) {
    return dateTime.toString().split(' ').first;
  }

  Container _inputTipoPago() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButton<String>(
        //isExpanded: true,
        underline: const SizedBox(),
        hint: Text('Tipo de pago'),
        value: selectedPayment,
        items: paymentOptions
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedPayment = newValue!;
            paymentType = selectedPayment;
          });
        },
      ),
    );
  }

  Container _inputEstado() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButton<String>(
        //isExpanded: true,
        underline: const SizedBox(),
        hint: Text('Estado de transaccion'),
        value: selectedStatus,
        items: statusOptions
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedStatus = newValue!;
            status = selectedStatus;
          });
        },
      ),
    );
  }

  Container _inputIdCliente() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: idClientController,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Cliente',
          labelText: 'Identificación del cliente',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingrese la identificación del cliente';
          } else if (!validarCedula(value)) {
            return 'Cédula no válida';
          }
        },
        onChanged: (value) {
          idClient = value;
        },
      ),
    );
  }
}
