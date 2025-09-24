import 'package:fpdart/fpdart.dart';
import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/core/usecase/usecase.dart';
import 'package:mini_store/features/product/domain/entities/product.dart';
import 'package:mini_store/features/product/domain/repositories/product_repository.dart';

class GetAllProducts implements Usecase<List<Product>, NoParams>{
  final ProductRepository productRepository;

  GetAllProducts({required this.productRepository});

  @override
  Future<Either<Failures, List<Product>>> call(NoParams params) async{
    return await productRepository.getAllProducts();
  }

}
