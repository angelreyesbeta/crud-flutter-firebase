

import 'dart:io';

import 'package:formvalidation/src/provider/productos_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class ProductosBloc{

  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider=new ProductoProvider();

  Stream<List<ProductoModel>> get productoStream=>_productosController.stream;
  Stream<bool> get cargando=>_cargandoController.stream;

  void cargarProductos()async{
    final productos=await _productosProvider.cargarProducto();
    _productosController.sink.add(productos);
  }

  void agregarProductos(ProductoModel producto) async{

    _cargandoController.sink.add(true);

    await _productosProvider.crearProducto(producto);

    _cargandoController.sink.add(false);

  }

  Future<String> subirFoto(File foto) async{

    _cargandoController.sink.add(true);
    final fotoUrl=await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;

  }

  void editarrProductos(ProductoModel producto) async{

    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto(producto);
    _cargandoController.sink.add(false);

  }

  void borrarProductos(String id) async{


    await _productosProvider.borrarProducto(id);


  }

  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }





}