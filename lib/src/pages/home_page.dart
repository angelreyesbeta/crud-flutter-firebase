import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/provider/productos_provider.dart';

class HomePage extends StatelessWidget {
  //final productosProvider= new ProductoProvider();
  @override
  Widget build(BuildContext context) {

    //final bloc = Provider.of(context);

    final productosBloc= Provider.productosBloc(context);
    productosBloc.cargarProductos();
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', style: TextStyle(color: Colors.white),),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
      
    );
  }

  Widget _crearListado(ProductosBloc productosBloc){

    return StreamBuilder(
      stream: productosBloc.productoStream,
      builder:(BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){

          final productos=snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context,i) =>_crearItem(productosBloc,context,productos[i]),
           
          );

        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      },
    );



  }

  Widget _crearItem(ProductosBloc productosBloc, BuildContext context, ProductoModel producto){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,

      ),
      onDismissed: (direccion){
        //Borrar Prodcuto
        productosBloc.borrarProductos(producto.id);
      },

      child: Card(
        child:Column(
          children: <Widget>[
            //Operador Ternario
            (producto.fotoUrl==null) 
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              image: NetworkImage(producto.fotoUrl),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: (){
                Navigator.pushNamed(context, 'producto', arguments: producto);
              },
            ),
          ],
        )
      )
    );
  }



  _crearBoton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: ()=>Navigator.pushNamed(context, 'producto'),
      backgroundColor:Colors.deepOrangeAccent//.fromRGBO(51, 192, 226, 1.0),
    );
  }
}