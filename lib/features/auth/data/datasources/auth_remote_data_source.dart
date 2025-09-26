import 'package:mini_store/core/error/exceptions.dart';
import 'package:mini_store/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPasword({required email, required password});

  Future<void> logout();

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPasword({
    required email,
    required password,
  }) async {
    try {
      final respons = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (respons.user == null) {
        throw const ServerException('User does not exist');
      }
      return UserModel.fromJeson(respons.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final respons = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (respons.user == null) {
        throw ServerException('User does not exist');
      }
      return UserModel.fromJeson(respons.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

    @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select() // 'profiles' is the name of the table in supabase database where we store user data, select() is used to fetch the entire column from the table
            .eq(
              'id',
              currentUserSession!.user.id,
            ); // eq() is used to filter the data based on a condition, here we are filtering the data where the id column is equal to the current user's id
        return UserModel.fromJeson(userData[0]);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
