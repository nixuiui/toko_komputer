import 'package:flutter/material.dart';
import 'package:toko_komputer/core/api/main_api.dart';
import 'package:toko_komputer/core/model/account_model.dart';

class AuthApi extends MainApi {
  
  Future<AccountModel> login({
    @required String username,
    @required String password
  }) async {
    try {
      final response = await postRequest(
        url: "$host/admin/login",
        body: {
          "email": username,
          "password": password
        }
      );
      return accountModelFromMap(response);
    } catch (error) {
      throw error;
    }
  }
  
  Future<AccountModel> getProfile() async {
    try {
      final response = await getRequest(
        url: "$host/admin/me",
        useAuth: true
      );
      return accountModelFromMap(response);
    } catch (error) {
      throw error;
    }
  }
  
  Future<AccountModel> editProfile({
    @required AccountModel data
  }) async {
    try {
      final response = await patchRequest(
        url: "$host/admin/update",
        body: data.toEditAccountMap(),
        useAuth: true
      );
      return accountModelFromMap(response);
    } catch (error) {
      throw error;
    }
  }
  
}