import 'package:flutter_app/infrastructure/di/di.dart';
import 'package:flutter_app/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/domain/entities/user.dart';
import 'package:flutter_app/infrastructure/services/ganalytics_service.dart';
import 'package:flutter_app/infrastructure/services/heap_service.dart';
import 'package:flutter_app/infrastructure/services/posthog_service.dart';
import 'package:flutter_app/infrastructure/utils.dart';
import 'package:flutter_app/presentation/bloc/user/user_cubit.dart';
import 'package:flutter_app/presentation/bloc/home/home_cubit.dart';
import 'package:flutter_app/presentation/widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.homeCubit});

  final HomeCubit homeCubit;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserCubit userCubit = getIt<UserCubit>();
  late final ProfileCubit profileCubit = getIt<ProfileCubit>();

  User? user;

  @override
  void initState() {
    super.initState();
    user = Utils.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: "Home",
        removeLeading: true,
        actions: [
          InkWell(
            onTap: () => _handleAccountIconTap(context),
            child: const SizedBox(
                width: 30,
                height: 26,
                child: Icon(Icons.account_circle_outlined)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleView(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Home'),
            ),
          ],
        ),
      )
    );
  }

  void _handleAccountIconTap(BuildContext context) {
    user = Utils.getUser();
    if (user != null) {
      getIt<AnalyticsService>().track("user_profile");
      HeapService().trackEvent("user_profile");
      PosthogService().trackEvent(eventName: "user_profile");
      Navigator.pushNamed(context, 'profile', arguments: profileCubit);
    } else {
      getIt<AnalyticsService>().track("user_login");
      HeapService().trackEvent("user_login");
      PosthogService().trackEvent(eventName: "user_login");
      Navigator.pushNamed(context, 'login');
    }
  }

  Widget titleView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 10,
        left: 16,
        right: 16,
        bottom: 5,
      ),
      child: Text(
        'Home title',
        style: Theme.of(context).textTheme.titleLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
