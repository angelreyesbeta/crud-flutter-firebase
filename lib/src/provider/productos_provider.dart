import 'dart:io';

import 'package:formvalidation/src/preferencias_usuario/preferencia_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductoProvider{

  final String _url='https://flutter-varios-fa11e.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async{

    final url='$_url/productos.json?auth=${_prefs.token}';

    final resp=await http.post(url, body: productoModelToJson(producto));

    final decodeData=json.decode(resp.body);

    print(decodeData);

    return true;

  }

  Future<bool> editarProducto(ProductoModel producto) async{

    final url='$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final resp=await http.put(url, body: productoModelToJson(producto));

    final decodeData=json.decode(resp.body);

    print(decodeData);

    return true;

  }


  Future<List<ProductoModel>> cargarProducto()async{

    final url='$_url/productos.json?auth=${_prefs.token}';
    final resp=await http.get(url);

    final Map<String,dynamic> decodeData=json.decode(resp.body);

    final List<ProductoModel> productos = new List();

    if(decodeData==null) return [];

    if(decodeData['error']!=null){
      return [];
    }

    decodeData.forEach((id,prod) { 

      final prodTemp=ProductoModel.fromJson(prod);
      prodTemp.id=id;

      productos.add(prodTemp);

    });

    //print(productos);

    return productos;


  }

  Future<int>borrarProducto(String id) async{
    final url='$_url/productos/$id.json?auth=${_prefs.token}';
    final resp=await http.delete(url);

    print(resp.body);

    return 1;

  }


  Future<String>subirImagen(File imagen) async {

    final url=Uri.parse('https://api.cloudinary.com/v1_1/betappsoft/image/upload?upload_preset=mn3avlwp');
    final mimeType= mime(imagen.path).split('');

    final imagenUploadRequest=http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
      );

      imagenUploadRequest.files.add(file);

      final streamResponse= await imagenUploadRequest.send();
      final resp=await http.Response.fromStream(streamResponse);

      if(resp.statusCode!=200 && resp.statusCode != 201){
        print('Algo salio Mal');
        print(resp.body);
        return null;
      }

      final resData = json.decode(resp.body);
      print(resData);

      return resData['secure_url'];

  }



}