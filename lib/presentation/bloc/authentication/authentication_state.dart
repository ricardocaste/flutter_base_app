part of 'authentication_cubit.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}
class AuthenticationLoading extends AuthenticationState {}
class AuthenticationSuccess extends AuthenticationState {
  final mem.User user;
  AuthenticationSuccess(this.user);
}
class AuthenticationFailure extends AuthenticationState {
  final String errorCode;
  AuthenticationFailure(this.errorCode);
}
class AuthenticationSignedOut extends AuthenticationState{}