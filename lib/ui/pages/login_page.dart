import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:toko_komputer/core/bloc/auth/auth_bloc.dart';
import 'package:toko_komputer/core/bloc/auth/auth_event.dart';
import 'package:toko_komputer/core/bloc/auth/auth_state.dart';
import 'package:toko_komputer/ui/pages/admin/home_admin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var bloc = AuthBloc();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: bloc,
      listener: (context, state) {
        if(state is AuthLoginSuccess) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomeAdminPage()
          ));
        } else if(state is AuthFailure) {
          setState(() {
            isLoading = false;
          });
          Toast.show(state.error, context);
        }
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email/Username"),
              TextFormField(
                controller: usernameController,
              ),
              SizedBox(height: 32),
              Text("Password"),
              TextFormField(
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(height: 32),
              Container(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: isLoading ? null : () => login(),
                  child: Text("LOGIN"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  login() {
    if(usernameController.text == null || usernameController.text == "") 
      Toast.show("Username tidak boleh kosong", context);
    else if(passwordController.text == null || passwordController.text == "") 
      Toast.show("Password tidak boleh kosong", context);
    else {
      setState(() {
        isLoading = true;
      });
      bloc.add(Login(username: usernameController.text, password: passwordController.text));
    }
  }
}