import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:flutter_app/infrastructure/di/di.dart';
import 'package:flutter_app/data/providers/firestore_provider.dart';
import 'package:flutter_app/domain/repositories/authentication_repository.dart';
import 'package:flutter_app/domain/entities/user.dart' as mem;
import 'package:flutter_app/infrastructure/services/branch_service.dart';
import 'package:flutter_app/infrastructure/services/ganalytics_service.dart';
import 'package:flutter_app/infrastructure/services/heap_service.dart';
import 'package:flutter_app/infrastructure/services/posthog_service.dart';
import 'package:flutter_app/presentation/bloc/user/user_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'authentication_state.dart';
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this.authenticationRepository, this.firestoreProvider) : super(AuthenticationInitial());

  final AuthenticationRepository authenticationRepository;
  final FirestoreProvider firestoreProvider;

  Future<void> ghostLogin() async {
    var authUser = authenticationRepository.getCurrentUser();

    if(authUser == null) return;

    final userCubit = getIt<UserCubit>();
    final mem.User? updatedUser = await userCubit.getUser(authUser.uid);

    if (updatedUser != null) {
      Get.put(updatedUser, tag: 'user');
      emit(AuthenticationSuccess(updatedUser));
    }
  }

  Future<void> logInWithApple() async =>
      await _authenticate(() => authenticationRepository.signInWithApple());


  Future<void> logInWithGoogle() async =>
      await _authenticate(() => authenticationRepository.signInWithGoogle());


  Future<void> logInWithEmailAndPassword(String email, String password) async {
    final userExists = await firestoreProvider.existUserWithEmail(email);
    if(userExists) {
      logIn(email, password);
    } else {
      signUp(email, password);
    }
  }

  Future<void> logIn(String email, String password) async =>
      await _authenticate(() => authenticationRepository.signInWithEmailAndPassword(email:email, password: password));


  Future<void> signUp(String email, String password) async =>
      await _authenticate(() => authenticationRepository.createUserWithEmailAndPassword(email:email, password: password));


  Future<void> _authenticate(Future<UserCredential?> Function() authMethod) async {
    try {
      emit(AuthenticationLoading());
      final userCredential = await authMethod();

      if (userCredential != null) {
        final firebaseUser = userCredential.user!;
        bool userExists = false; 
        if (firebaseUser.email == null) {
          userExists = false;
        } else {
          userExists = await firestoreProvider.existUserWithEmail(firebaseUser.email!);
        }

        if (!userExists) {
          final user = mem.User(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name: firebaseUser.displayName ?? '',
            hasPurchased: false,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
          );
          await firestoreProvider.createUser(user);
        }
        final userCubit = getIt<UserCubit>();
        final mem.User? updatedUser = await userCubit.getUser(firebaseUser.uid);

        if (updatedUser != null) {
          String event = "login";

          if (!userExists) {
            event = "signup";
          }

          Get.put(updatedUser, tag: 'user');

          try {
            BranchService().login(updatedUser.uid);
            BranchService().trackingEvents("Login success", "User login success", {
              "user_id": updatedUser.uid,
              "user_email": updatedUser.email,
              "user_name": updatedUser.name,
            }, BranchStandardEvent.LOGIN);

            getIt<AnalyticsService>().setUserId(updatedUser.uid);
            getIt<AnalyticsService>().track(event);
            HeapService().trackEvent(event);
            HeapService().identifyUser(updatedUser.uid);
            PosthogService().trackEvent(eventName: event);
            PosthogService().identifyUser(userId: updatedUser.uid);

          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
          
          emit(AuthenticationSuccess(updatedUser));
        } else {
          getIt<AnalyticsService>().track("user_login_failed");
          HeapService().trackEvent("user_login_failed");
          PosthogService().trackEvent(eventName: "user_login_failed");
          emit(AuthenticationFailure('authentication-failed'));
        }

      } else {
        emit(AuthenticationFailure('authentication-failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationFailure(e.code)); 
    } catch (e) {
      emit(AuthenticationFailure('$e'));
    }
  }

  Future<void> logOut() async {
    try {
      getIt<AnalyticsService>().track("user_logout");
      HeapService().trackEvent("user_logout");
      PosthogService().trackEvent(eventName: "user_logout");
      BranchService().logout();

      await authenticationRepository.signOut();
      Get.delete<User>(tag: 'user');
      emit(AuthenticationSignedOut());
    } catch (e) {
      emit(AuthenticationFailure('sign-out-error'));
    }
  }
}