part of 'wishlist_cubit.dart';

@immutable
sealed class WishlistState {
  final List<int> wishlistProductIds;
  const WishlistState(this.wishlistProductIds);
}

final class WishlistInitial extends WishlistState {
  WishlistInitial() : super([]);
}

final class WishlistUpdated extends WishlistState {
  const WishlistUpdated(super.wishlistProductIds);
}