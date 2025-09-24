import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_store/core/error/exceptions.dart';
import 'package:mini_store/features/product/data/models/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response =
          await client.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final products = data.map((e) => ProductModel.fromJson(e)).toList();
        return products;
      } else {
        throw ServerException('Server Error!');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}