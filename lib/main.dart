import 'package:flutter/material.dart';

import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';

import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/pages/producto_page.dart';
import 'package:formvalidation/src/pages/registro_page.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencia_usuario.dart';
 
void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    print('El token es : ${prefs.token}'); 
    return Provider(
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context)=>LoginPage(),
          'home': (BuildContext context)=>HomePage(),
          'producto': (BuildContext context)=>ProductoPage(),
          'registroU': (BuildContext context)=>RegistroPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepOrangeAccent//  .fromRGBO(51, 192, 226, 1.0),
        ),

      )
    );

    
  }
}