import 'package:apppagoplux/src/pages/pay.dart';
import 'package:flutter/material.dart';

class appPagoPlux extends StatefulWidget {
  //appPagoPlux({Key key}) : super(key: key);

  const appPagoPlux({super.key});

  @override
  State<appPagoPlux> createState() => _appPagoPluxState();
}

class _appPagoPluxState extends State<appPagoPlux> {
  String name = '';
  String email = '';
  String password = '';
  bool _seePassword = true;
  final _formfield= GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
        children: <Widget>[
          Form(
            key: _formfield,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/pagopluxlogo.png'),
                ),
                const Text(
                  'PagoPlux',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 50.0, fontWeight: FontWeight.bold),
                ),
                //const SizedBox(height: 10,),
                const Text(
                  'Realizado por Jorge R. Luna',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 15.0),
                ),
                const SizedBox(height: 10,),
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 25.0),
                ),
                SizedBox(
                  width: 350.0,
                  height: 15.0,
                  child: Divider(
                    color: Colors.blueGrey[600],
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                      hintText: 'Nombre de usuario',
                      labelText: 'Nombre de usuario',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Ingresa un nombre de usuario';
                    } else if(value!='Pagoplux'){
                      return 'Nombre de usuario incorrecto';
                    }
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordController,
                  enableInteractiveSelection: false,
                  obscureText: _seePassword,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _seePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _seePassword = !_seePassword;
                        });
                      },
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Ingresa una contraseña';
                    } else if(value!='Pagoplux'){
                      return 'Contraseña incorrecta';
                    }
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: (){
                    if(_formfield.currentState!.validate()){
                      print('Completado');
                      usernameController.clear();
                      passwordController.clear();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Pay()));
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: const Center(
                      child: Text(
                        'Ingresar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold
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
}
