import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/usecase/usecase.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:mini_store/features/product/domain/usecases/get_all_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts _getAllProducts;
  ProductBloc({required GetAllProducts getAllProducts})
    : _getAllProducts = getAllProducts,
      super(ProductInitial()) {
    on<ProductEvent>((event, emit) {
      emit(ProductLoading());
    });
    on<FetchAllProducts>(_onFetchAllProducts);
  }

  void _onFetchAllProducts(
    FetchAllProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    await _getAllProducts(NoParams()).then((result) {
      result.fold(
        (failure) {
          emit(ProductFailure(message: failure.message));
        },
        (products) {
          emit(FetchSuccess(products: products));
        },
      );
    });
  }
}
