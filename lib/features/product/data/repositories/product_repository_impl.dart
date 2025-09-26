import 'package:fpdart/src/either.dart';
import 'package:mini_store/core/constants/constants.dart';
import 'package:mini_store/core/error/exceptions.dart';
import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/core/network/connection_checker.dart';
import 'package:mini_store/features/product/data/datasources/product_remote_data_source.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:mini_store/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  ProductRepositoryImpl({required this.remoteDataSource,required this.connectionChecker});
  @override
  Future<Either<Failures, List<Product>>> getAllProducts() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures(message: Constants.noConnectionErrorMessage));
      }
      final products = await remoteDataSource.getAllProducts();
      return right(products);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }
}
