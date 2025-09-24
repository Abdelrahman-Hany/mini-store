import 'package:fpdart/src/either.dart';
import 'package:mini_store/core/error/exceptions.dart';
import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/features/product/data/datasources/product_remote_data_source.dart';
import 'package:mini_store/features/product/domain/entities/product.dart';
import 'package:mini_store/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failures, List<Product>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return right(products);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }
}
