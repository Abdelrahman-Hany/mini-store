import 'package:flutter/material.dart';

@immutable
sealed class AuthEvent {}

final class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({
    required this.email,
    required this.password,
  });
}

final class CheckCurrentUserEvent extends AuthEvent{}

final class AuthLogoutEvent extends AuthEvent {}