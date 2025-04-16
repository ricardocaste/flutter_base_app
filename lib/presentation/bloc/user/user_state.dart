part of 'user_cubit.dart';

abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserEditing extends UserState {}
class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}
class UserEdited extends UserState {
  final User user;
  UserEdited(this.user);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}
class UserPurchasing extends UserState {}
class UserPurchased extends UserState {
  final User user;
  UserPurchased(this.user);
}
class UserPurchasedError extends UserState {}