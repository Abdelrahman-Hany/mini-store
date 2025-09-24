import 'package:fpdart/fpdart.dart';
import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/features/product/domain/entities/product.dart';

abstract interface class ProductRepository {
  Future<Either<Failures, List<Product>>> getAllProducts();
}
