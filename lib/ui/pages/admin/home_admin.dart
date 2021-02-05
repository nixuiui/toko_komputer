import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toko_komputer/core/bloc/auth/auth_bloc.dart';
import 'package:toko_komputer/core/bloc/auth/auth_event.dart';
import 'package:toko_komputer/core/bloc/auth/auth_state.dart';
import 'package:toko_komputer/ui/pages/admin/category/category_page.dart';
import 'package:toko_komputer/ui/pages/admin/product/product_page.dart';
import 'package:toko_komputer/ui/pages/home_page.dart';

class HomeAdminPage extends StatefulWidget {
  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {

  var bloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: bloc,
      listener: (context, state) {
        if(state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => HomePage()), 
            (route) => false
          );
        }
      },
      child: Scaffold(
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
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Keluar"),
              onTap: () => bloc.add(Logout())
            ),
            Divider(),
          ],
        )
      ),
    );
  }
}