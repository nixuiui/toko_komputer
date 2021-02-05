import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toko_komputer/core/bloc/category/category_bloc.dart';
import 'package:toko_komputer/core/bloc/category/category_event.dart';
import 'package:toko_komputer/core/bloc/category/category_state.dart';
import 'package:toko_komputer/core/model/category_model.dart';
import 'package:toko_komputer/ui/pages/admin/category/category_form.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  var bloc = CategoryBloc();
  var categories = <Category>[];
  var isStarting = true;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() {
    bloc.add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: bloc,
      listener: (context, state) {
        if(state is CategoryLoaded) {
          setState(() {
            isStarting = false;
            categories = state.data;
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
              Expanded(
                child: ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => Divider(height: 0), 
                  itemBuilder: (context, index) => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CategoryForm(category: categories[index])
                          )).then((value) => bloc.add(LoadCategories())),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Text(categories[index].name)
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(16),
                        icon: Icon(Icons.delete, color: Colors.red), 
                        onPressed: (){
                          setState(() {
                            bloc.add(DeleteCategory(id: categories[index].id));
                            categories.removeAt(index);
                          });
                        }
                      )
                    ],
                  ), 
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  child: Text("Tambah Kategori"),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CategoryForm()
                  )).then((value) => bloc.add(LoadCategories()))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}