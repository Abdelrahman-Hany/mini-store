import 'package:mini_store/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:mini_store/core/usecase/usecase.dart';
import 'package:mini_store/core/common/entities/user.dart';
import 'package:mini_store/features/auth/domain/usecases/current_user.dart';
import 'package:mini_store/features/auth/domain/usecases/user_login.dart';
import 'package:mini_store/features/auth/domain/usecases/user_logout.dart';
import 'package:mini_store/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp
  _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserLogout _userLogout;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserLogout userLogout,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
        _userLogout = userLogout,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading())); 
    on<SignUpEvent>(_onAuthSignUp);
    on<LoginEvent>(_onAuthLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<CheckCurrentUserEvent>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    CheckCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    // emit(AuthLoading());
    await _currentUser(NoParams()).then((value) {
      value.fold(
        (onLeft) {
          emit(AuthFailure(message: onLeft.message));
        },
        (onRight) {
          _emitAuthSuccess(onRight, emit);
        },
      );
    });
  }

  void _onAuthSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    ).then((result) {
      result.fold(
        (onLeft) {
          emit(AuthFailure(message: onLeft.message));
        },
        (onRight) {
          _emitAuthSuccess(onRight, emit);
        },
      );
    });
  }

  void _onAuthLogin(LoginEvent event, Emitter<AuthState> emit) async {
    await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    ).then((result) {
      result.fold(
        (onLeft) {
          emit(AuthFailure(message: onLeft.message));
        },
        (onRight) {
          _emitAuthSuccess(onRight, emit);
        },
      );
    });
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await _userLogout(NoParams()).then((result) {
      result.fold(
        (onLeft) {
          emit(AuthFailure(message: onLeft.message));
        },
        (onRight) {
          _appUserCubit.updateUser(null);
          emit(AuthInitial());
        },
      );
    });
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
