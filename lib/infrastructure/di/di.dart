import 'package:flutter_app/data/datasources/profile_remote_datasource.dart';
import 'package:flutter_app/data/providers/firestore_provider.dart';
import 'package:flutter_app/data/repositories/authentication_repository_impl.dart';
import 'package:flutter_app/data/repositories/profile_repository_impl.dart';
import 'package:flutter_app/data/repositories/user_repository_impl.dart';
import 'package:flutter_app/domain/repositories/authentication_repository.dart';
import 'package:flutter_app/domain/repositories/profile_repository.dart';
import 'package:flutter_app/domain/repositories/user_repository.dart';
import 'package:flutter_app/infrastructure/services/branch_service.dart';
import 'package:flutter_app/infrastructure/services/ganalytics_service.dart';
import 'package:flutter_app/presentation/bloc/authentication/authentication_cubit.dart';
import 'package:flutter_app/presentation/bloc/home/home_cubit.dart';
import 'package:flutter_app/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_app/presentation/bloc/user/user_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {

   // Analytics
  getIt.registerSingletonAsync<AnalyticsService>(() async {
    final service = AnalyticsService();
    await service.init();
    return service;
  });
  getIt.registerLazySingleton<BranchService>(() => BranchService());


  // Blocs / Cubits
  getIt.registerFactory<AuthenticationCubit>(() => AuthenticationCubit(getIt(), getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));

  // Use cases

  // Providers
  getIt.registerLazySingleton<FirestoreProvider>(() => FirestoreProvider());

  // Repositories
  getIt.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl());
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(getIt()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));
  
  

  // Data sources
  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSource());

  // External
} 