import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:toko_komputer/core/bloc/category/category_bloc.dart';
import 'package:toko_komputer/core/bloc/category/category_event.dart';
import 'package:toko_komputer/core/bloc/category/category_state.dart';
import 'package:toko_komputer/core/bloc/product/product_bloc.dart';
import 'package:toko_komputer/core/bloc/product/product_event.dart';
import 'package:toko_komputer/core/bloc/product/product_state.dart';
import 'package:toko_komputer/core/model/category_model.dart';
import 'package:toko_komputer/core/model/option_model.dart';
import 'package:toko_komputer/core/model/product_model.dart';
import 'package:toko_komputer/ui/widget/select_from_gallery.dart';
import 'package:toko_komputer/ui/widget/select_option.dart';

class ProductForm extends StatefulWidget {

  const ProductForm({
    Key key,
    this.product,
  }) : super(key: key);
  
  final Product product;

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  var nameController = TextEditingController();
  var merkProductController = TextEditingController();
  var buyPriceController = TextEditingController();
  var sellPriceController = TextEditingController();
  var descriptionController = TextEditingController();
  var stockController = TextEditingController();
  var photos = <File>[];
  var photosMultiPart = <MultipartFile>[];

  var categoryBloc = CategoryBloc();
  var categories = <OptionsModel<Category>>[];
  OptionsModel<Category> category;

  var bloc = ProductBloc();
  var isLoading = false;

  @override
  void initState() {
    categoryBloc.add(LoadCategories());
    if(widget.product != null) {
      nameController.text = widget.product.name;
      merkProductController.text = widget.product.merkProduct;
      buyPriceController.text = widget.product.buyPrice.toString();
      sellPriceController.text = widget.product.sellPrice.toString();
      descriptionController.text = widget.product.description;
      stockController.text = widget.product.stock.toString();
      print("widget.product.category.toMap()");
      print(widget?.product?.toMap());
      category = OptionsModel(
        name: widget.product?.category?.name ?? "",
        value: widget.product.category
      );
      widget.product.images.forEach((e) async { 
        var file = await urlToFile(e);
        var multiFormdata = await MultipartFile.fromFile(file.path);
        photos.add(file);
        photosMultiPart.add(multiFormdata);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          cubit: bloc,
          listener: (context, state) {
            if(state is ProductCreated) {
              Navigator.pop(context);
            } else if(state is ProductUpdated) {
              Navigator.pop(context);
            } else if(state is ProductFailure) {
              setState(() {
                isLoading = false;
              });
            }
          }
        ),
        BlocListener(
          cubit: categoryBloc,
          listener: (context, state) {
            if(state is CategoryLoaded) {
              setState(() {
                categories = state.data.map((e) => OptionsModel(name: e.name, value: e)).toList();
              });
            }
          }
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Produk"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text("Nama Produk"),
                  TextFormField(
                    controller: nameController,
                  ),
                  SizedBox(height: 16),
                  Text("Merk"),
                  TextFormField(
                    controller: merkProductController,
                  ),
                  SizedBox(height: 16),
                  Text("Harga Modal"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: buyPriceController,
                  ),
                  SizedBox(height: 16),
                  Text("Harga Jual"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: sellPriceController,
                  ),
                  SizedBox(height: 16),
                  Text("Stok"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: stockController,
                  ),
                  SizedBox(height: 16),
                  Text("Kategori"),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => selectCategory(),
                    child: Container(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(child: Text(category != null ? category?.name : "Pilih Kategori")),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Deskripsi"),
                  TextFormField(
                    controller: descriptionController,
                    minLines: 6,
                    maxLines: 15,
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => selectFromGallery(),
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    children: photos.asMap().entries.map((value) => Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              photos.removeAt(value.key);
                              photosMultiPart.removeAt(value.key);
                            });
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: Image.file(value.value),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                photos.removeAt(value.key);
                                photosMultiPart.removeAt(value.key);
                              });
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Center(
                              child: Container(
                                width: 20,
                                height: 20,
                                color: Colors.white.withOpacity(0.8),
                                child: Center(child: Icon(Icons.close, size: 14)),
                              ),
                            ),
                          )
                        )
                      ],
                    )).toList()
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RaisedButton(
                child: Text("Simpan"),
                onPressed: () {
                  if(nameController.text == null || nameController.text == "") {
                    Toast.show("Nama harus diisi", context);
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    var data = ProductPost(
                      id: widget.product != null ? widget.product.id : "",
                      photo: photosMultiPart,
                      name: nameController?.text ?? "",
                      merkProduct: merkProductController?.text ?? "",
                      buyPrice: buyPriceController?.text ?? "",
                      sellPrice: sellPriceController?.text ?? "",
                      description: descriptionController?.text ?? "",
                      category: category?.value?.id ?? "",
                      stock: stockController?.text ?? "",
                    );
                    if(widget.product == null) {
                      bloc.add(CreateProduct(data: data));
                    } else {
                      bloc.add(UpdateProduct(data: data));
                    }
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  Future selectCategory() async {
    Map results = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectOptions(
        title: "Pilih Kategori",
        options: categories,
        selected: category,
        useFilter: true,
      )),
    );

    if (results != null && results.containsKey("data")) {
      setState(() {
        category = results["data"];
      });
    }
  }

  Future selectFromGallery() async {
    Map results = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => SelectFromGallery()
    ));

    if (results != null && results.containsKey("file")) {
      File file = results["file"];
      if(file.lengthSync() > 2000000) {
        Toast.show("Size gambar tidak boleh melebihi 2MB", context);
      } else {
        var multiFormdata = MultipartFile.fromFileSync(file.path);
        setState(() {
          photos.add(file);
          photosMultiPart.add(multiFormdata);
          print("photos.length");
          print(photos.length);
        });
      }
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    http.Response response = await http.get(imageUrl);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}