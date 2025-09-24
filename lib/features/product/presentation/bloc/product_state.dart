part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class FetchSuccess extends ProductState {
  final List<Product> products;
  FetchSuccess({required this.products});
}

final class ProductFailure extends ProductState {
  final String message;
  ProductFailure({required this.message});
}