import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'wishlist_state.dart';

const String wishlistKey = 'wishlist';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitial()) {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistIds = prefs.getStringList(wishlistKey) ?? [];
    emit(WishlistUpdated(wishlistIds.map((id) => int.parse(id)).toList()));
  }

  Future<void> toggleWishlist(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final currentWishlist = List<int>.from(state.wishlistProductIds);

    if (currentWishlist.contains(product.id)) {
      currentWishlist.remove(product.id);
    } else {
      currentWishlist.add(product.id);
    }

    await prefs.setStringList(
        wishlistKey, currentWishlist.map((id) => id.toString()).toList());
    emit(WishlistUpdated(currentWishlist));
  }

  bool isInWishlist(Product product) {
    return state.wishlistProductIds.contains(product.id);
  }
}