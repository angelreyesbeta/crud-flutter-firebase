
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/pages/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

import 'package:formvalidation/src/models/producto_model.dart';
//import 'package:formvalidation/src/provider/productos_provider.dart';

class ProductoPage extends StatefulWidget {
//ProductoModel producto = new ProductoModel();
  @override
  _ProductoPageState createState() => _ProductoPageState();
  
  
}

class _ProductoPageState extends State<ProductoPage> {

  final formkey=GlobalKey<FormState>();
  final scaffoldKey=GlobalKey<ScaffoldState>();
  //final productoProvider=new ProductoProvider();

  ProductosBloc productosBloc;

  ProductoModel producto = new ProductoModel();

  bool _guardando=false;

  File foto;
  


  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData=ModalRoute.of(context).settings.arguments;
    if(prodData!=null){
      producto=prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Titulo: ${producto.titulo}'),//,,style: TextStyle(color: Color.fromRGBO(51, 192, 226, 1.0),),),
        
        //backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            //color: Color.fromRGBO(51, 192, 226, 1.0),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            //color: Color.fromRGBO(51, 192, 226, 1.0),
            onPressed: _tomarFoto,
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
               _crearPrecio(),
               _crearDisponible(),
               _crearBoton(),
              ],

            ),
          ),
        ),
      ),
      
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value)=>producto.titulo=value,
      validator: (value){
        if(value.length<3){
          return 'Ingres el nombre del producto';
        }else{
          return null;
        }
      },

    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      //.numberWithOptions(decimal:true),
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value)=>producto.valor=double.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }else{
          return 'Solo número';
        }
      },
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepOrangeAccent,
      onChanged: (value)=>setState((){
        producto.disponible=value;
      }),

    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepOrangeAccent,// .fromRGBO(51, 192, 226, 1.0),
      textColor: Colors.white,
      icon: Icon(Icons.save), 
      label: Text('Guardar'),
      onPressed:(_guardando) ? null : _submi, 
    );
  }

  void _submi() async{

    if(!formkey.currentState.validate()) return;

    formkey.currentState.save();

    /* print('todo ok');

    print('Titulo: ${producto.titulo}');

    print('Valor: ${producto.valor}');

    print('Disponible: ${producto.disponible}'); */

    _guardando=true;

    setState(() {
      _guardando=true;
    });

    if(foto!=null){
      producto.fotoUrl= await productosBloc.subirFoto(foto);
    }

    if(producto.id==null){
      productosBloc.agregarProductos(producto);// .crearProducto(producto);
      mostrarSnackbar('Registro Guardado');
    }else{
      productosBloc.editarrProductos(producto);
      mostrarSnackbar('Registro Actualizado');
    }

    Navigator.pop(context);
    /* setState(() {
      _guardando=false;
    }); */

    

  }

  void mostrarSnackbar(String mensaje){
    final snackBar=SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _mostrarFoto(){
    if(producto.fotoUrl!=null){
      //Tengo que hacer esto
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else{
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  Future _seleccionarFoto() async {

   _procesarFoto(ImageSource.gallery);

  }


  _tomarFoto()async{

    _procesarFoto(ImageSource.camera );


  }

  _procesarFoto(ImageSource origen) async{

   foto=await ImagePicker.pickImage(
      source:origen
    );

    if(foto!=null){
      producto.fotoUrl=null;
      
    }

    setState(() {

      //_mostrarFoto();
      
    });

  }


}