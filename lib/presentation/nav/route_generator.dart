import 'package:flutter/material.dart';
import 'package:flutter_app/infrastructure/services/navigation_service.dart';
import 'package:flutter_app/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_app/presentation/nav/nav_bar.dart';
import 'package:flutter_app/presentation/pages/auth/login_page.dart';
import 'package:flutter_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:flutter_app/presentation/pages/profile/profile_page.dart';
import 'package:flutter_app/presentation/pages/splash/splash.dart';

class RouteGenerator {

  static final navigationService = NavigationService();

  static Route<dynamic> generateRouter(RouteSettings settings) {
    navigationService.updateRoute(settings.name ?? '');

    switch (settings.name) {
      case '/':
        return buildTransition(const Splash(), settings: settings);
      case 'login':
         return buildTransition( LoginPage(), settings: settings);
      case 'profile':
        final profileCubit = settings.arguments as ProfileCubit;
        return buildTransition(ProfilePage(profileCubit: profileCubit), settings: settings);
      case 'nav':
        return buildTransition(const NavBar(), settings: settings);
      case 'onboarding':
        return buildTransition(const OnBoardingPage(), settings: settings);
      default:
        return _errorRoute();
    }
  }

  static PageRouteBuilder buildTransition(Widget view, { RouteSettings? settings}){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => view,
      settings: settings ?? const RouteSettings() ,
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}