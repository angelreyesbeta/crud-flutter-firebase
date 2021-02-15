
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{

  static final PreferenciasUsuario _instancia=new PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){
    
    return _instancia;

  }

  PreferenciasUsuario._internal();


  SharedPreferences _prefs;

  initPrefs()async{
    this._prefs=await SharedPreferences.getInstance();
  }

  // ninguna de estas propiedades se usan
 /*  bool   _colorSecundario;
  int    _genero;
  String _nombre; */



  get token{
    return _prefs.getString('token') ?? '';
  }

  set token(String value){
    _prefs.setString('token', value);
  }




}