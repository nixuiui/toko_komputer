import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toko_komputer/core/bloc/product/product_bloc.dart';
import 'package:toko_komputer/core/bloc/product/product_event.dart';
import 'package:toko_komputer/core/bloc/product/product_state.dart';
import 'package:toko_komputer/core/model/product_model.dart';
import 'package:toko_komputer/ui/pages/admin/product/product_form.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  var bloc = ProductBloc();
  var products = <Product>[];
  var isStarting = true;

  var controller = TextEditingController();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() {
    bloc.add(LoadProducts(
      isRefresh: true,
      search: controller?.text ?? ""
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: bloc,
      listener: (context, state) {
        if(state is ProductLoaded) {
          setState(() {
            isStarting = false;
            products = state.data;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Produk"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      onFieldSubmitted: (value) {
                        controller?.text = value;
                        refresh();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isStarting = true;
                      });
                      refresh();
                    },
                  )
                ],
              ),
              Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (context, index) => Divider(height: 0), 
                  itemBuilder: (context, index) => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProductForm(product: products[index])
                          )).then((value) => bloc.add(LoadProducts(isRefresh: true))),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey[200],
                                  child: Image.network(products[index].images.length > 0 ? products[index].images[0] : "")
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(products[index].name),
                                      Text(products[index]?.category?.name ?? ""),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(16),
                        icon: Icon(Icons.delete, color: Colors.red), 
                        onPressed: (){
                          setState(() {
                            bloc.add(DeleteProduct(id: products[index].id));
                            products.removeAt(index);
                          });
                        }
                      )
                    ],
                  ), 
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: RaisedButton(
                  child: Text("Tambah Produk"),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductForm()
                  )).then((value) => bloc.add(LoadProducts(isRefresh: true)))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}