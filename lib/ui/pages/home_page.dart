import 'package:flutter/material.dart';
import 'package:toko_komputer/helper/shared_preferences.dart';
import 'package:toko_komputer/ui/items/product_item.dart';
import 'package:toko_komputer/ui/pages/admin/home_admin.dart';
import 'package:toko_komputer/ui/pages/login_page.dart';
import 'package:toko_komputer/ui/pages/product_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var isAuthenticated = false;

  @override
  void initState() {
    SharedPreferencesHelper.isAuthenticated().then((value) => setState(() => isAuthenticated = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        actions: [
          IconButton(
            icon: Icon(Icons.people), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => isAuthenticated ? HomeAdminPage() : LoginPage()
            )).then((value) => SharedPreferencesHelper.isAuthenticated().then((value) => setState(() => isAuthenticated = value)))
          )
        ],
      ),
      body: ListView.separated(
        itemCount: 20,
        separatorBuilder: (context, index) => Divider(), 
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProductDetail()
            )),
            child: ProductItem()
          );
        }, 
      ),
    );
  }
}