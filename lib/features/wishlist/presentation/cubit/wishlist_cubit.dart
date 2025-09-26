import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final AppUserCubit _appUserCubit;
  WishlistCubit({required AppUserCubit appUserCubit})
      : _appUserCubit = appUserCubit,
        super(WishlistInitial());

  String? _getCurrentUserId() {
    final state = _appUserCubit.state;
    if (state is AppUserLoggedIn) {
      return state.user.id;
    }
    return null;
  }

  Future<void> loadUserWishlist() async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final wishlistKey = 'wishlist_$userId';
    final wishlistIds = prefs.getStringList(wishlistKey) ?? [];
    emit(WishlistUpdated(wishlistIds.map((id) => int.parse(id)).toList()));
  }

  Future<void> _saveWishlist(List<int> productIds) async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final wishlistKey = 'wishlist_$userId';
    await prefs.setStringList(
        wishlistKey, productIds.map((id) => id.toString()).toList());
  }

  Future<void> toggleWishlist(Product product) async {
    final currentWishlist = List<int>.from(state.wishlistProductIds);

    if (currentWishlist.contains(product.id)) {
      currentWishlist.remove(product.id);
    } else {
      currentWishlist.add(product.id);
    }

    emit(WishlistUpdated(currentWishlist));
    await _saveWishlist(currentWishlist);
  }

  bool isInWishlist(Product product) {
    return state.wishlistProductIds.contains(product.id);
  }

  void clearWishlist() {
    emit(WishlistInitial());
  }
}