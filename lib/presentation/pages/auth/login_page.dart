import 'package:flutter_app/infrastructure/constants/constants.dart';
import 'package:flutter_app/presentation/bloc/profile/profile_cubit.dart';
import 'package:azbox/azbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/infrastructure/constants/app_colors.dart';
import 'package:flutter_app/infrastructure/di/di.dart';
import 'package:flutter_app/infrastructure/services/ganalytics_service.dart';
import 'package:flutter_app/infrastructure/services/heap_service.dart';
import 'package:flutter_app/infrastructure/services/posthog_service.dart';
import 'package:flutter_app/presentation/bloc/authentication/authentication_cubit.dart';
import 'package:flutter_app/presentation/bloc/home/home_cubit.dart';
import 'package:flutter_app/presentation/widgets/app_bar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final authenticationCubit = getIt<AuthenticationCubit>();

    return BlocProvider.value(
      value: authenticationCubit, 
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {

          if (state is AuthenticationSuccess) {
            final profileCubit = getIt<ProfileCubit>();
            profileCubit.loadProfile();
            Navigator.of(context).pushNamed('profile', arguments:profileCubit);
          } else if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Wrap(
                    children: [
                      Text(
                        'Authentication error',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(12),
                ),
              );
              
          }
        },
        builder: (BuildContext context, AuthenticationState state) {
          return  Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBarWidget(context: context),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'World',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 45),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: '${'Login page text before title'}\n'),
                          const WidgetSpan(child: SizedBox(height: 30)),
                          TextSpan(text: 'Login page text'.translate(capitalize: false)),
                        ],
                        style: const TextStyle(fontSize: 16),
                      ),
                      maxLines: 2,

                    ),
                    const SizedBox(height: 30),
                    const Spacer(),

                  state is AuthenticationLoading ?
                    const Center(child: CircularProgressIndicator(backgroundColor: AppColors.blue,)) :
                    _buildLoginButtons(context, authenticationCubit), 
                    const SizedBox(height: 40),
                    Center(
                      child:  RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: '${'Your first login creates your account, and by doing so, you accept our'} ',
                          style: const TextStyle(color: AppColors.main, fontSize: 12),
                          children: [
                            TextSpan(
                              text: 'Terms of service',
                              style: const TextStyle(color: AppColors.blue, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                    final Uri url = Uri.parse(Constants.termsOfServiceUrl);
                                      if (!await launchUrl(url)) {
                                        throw Exception('No se pudo abrir $url');
                                      }                                
                                    },
                            ),
                            TextSpan(text: ' and '.translate()),
                            TextSpan(
                              text: ' ${'Privacy policy'}',
                              style: const TextStyle(color: AppColors.blue, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                    final Uri url = Uri.parse(Constants.privacyPolicyUrl);
                                      if (!await launchUrl(url)) {
                                        throw Exception('No se pudo abrir $url');
                                      }                                
                                    },
                            ),
                            const TextSpan(
                              text: '.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }

  Widget _buildLoginButtons(BuildContext context, AuthenticationCubit authenticationCubit) {
    return Column(
      children: [
        if (Platform.isIOS)
          ElevatedButton(
            onPressed: () {
              try {
                getIt<AnalyticsService>().track("login_with_apple");
                HeapService().trackEvent("login_with_apple");
                PosthogService().trackEvent(eventName: "login_with_apple");
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
              authenticationCubit.logInWithApple();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: const Size(double.infinity, 50)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.apple, color: Colors.black, size: 24),
                const SizedBox(width: 8),
                Text('Sign in with Apple'.replaceAll('apple', 'Apple')),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  try {
                    getIt<AnalyticsService>().track("login_with_google");
                    HeapService().trackEvent("login_with_google");
                    PosthogService().trackEvent(eventName: "login_with_google");
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                  authenticationCubit.logInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/google.svg',
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.main,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Google'), 
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  try { 
                    getIt<AnalyticsService>().track("login_with_email");
                    HeapService().trackEvent("login_with_email");
                    PosthogService().trackEvent(eventName: "login_with_email");
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                  showLoginDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, color: Colors.black, size: 20),
                    SizedBox(width: 8),
                    Text('Email'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void showLoginDialog(BuildContext context) {
    final authenticationCubit = getIt<AuthenticationCubit>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '${'Welcome back'}!',
                  style: TextStyle(
                    color: AppColors.blue, 
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: '${'Sign in or create an account'}\n'),
                      const WidgetSpan(child: SizedBox(height: 20)),
                      TextSpan(text: 'to continue learning'.translate(capitalize: false)),
                    ],
                    style: const TextStyle(fontSize: 14),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          content: SizedBox(
            height: 230, 
            child:  BlocProvider(
            create: (context) => authenticationCubit,
            child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationSuccess) {
                    final homeCubit = getIt<HomeCubit>();
                    homeCubit.loadHome();
                    Navigator.of(context).pushNamed('nav', arguments: state.user);
                  } else if (state is AuthenticationFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Authentication error'.translate()),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                              ),),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            autocorrect: false,
                            enableSuggestions: false,
                            autofillHints: const [],
                            decoration: InputDecoration(labelText: 'Password',
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                              ),),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          if (state is AuthenticationLoading) const CircularProgressIndicator(),
                          if (state is! AuthenticationLoading) ElevatedButton(
                            style: Theme.of(context).elevatedButtonTheme.style,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthenticationCubit>().logInWithEmailAndPassword(_emailController.text, _passwordController.text);
                              }
                            },
                            child: Text('Sign In',
                                style: Theme.of(context).elevatedButtonTheme.style!.textStyle!.resolve({})),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        );
      },
    );
  }
}