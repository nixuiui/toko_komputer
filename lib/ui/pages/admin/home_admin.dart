import 'package:flutter/material.dart';
import 'package:toko_komputer/ui/pages/admin/category/category_page.dart';
import 'package:toko_komputer/ui/pages/admin/product/product_page.dart';

class HomeAdminPage extends StatefulWidget {
  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Kedaton Komputer"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Kelola Kategori Produk"),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => CategoryPage()
            ))
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.layers),
            title: Text("Kelola Produk"),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProductPage()
            ))
          ),
          Divider(),
        ],
      )
    );
  }
}