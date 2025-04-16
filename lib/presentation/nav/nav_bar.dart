import 'dart:async';

import 'package:flutter_app/presentation/pages/settings/settings_page.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/infrastructure/di/di.dart';
import 'package:flutter_app/infrastructure/services/branch_service.dart';
import 'package:flutter_app/infrastructure/services/ganalytics_service.dart';
import 'package:flutter_app/infrastructure/services/heap_service.dart';
import 'package:flutter_app/infrastructure/services/posthog_service.dart';
import 'package:flutter_app/infrastructure/utils.dart';
import 'package:flutter_app/presentation/bloc/authentication/authentication_cubit.dart';
import 'package:flutter_app/presentation/bloc/home/home_cubit.dart';
import 'package:flutter_app/presentation/pages/home/home_page.dart';

typedef TabIndex = int;

class TabIndices {
  static const TabIndex home = 0;
  static const TabIndex player = 1;
  static const TabIndex learn = 2;
  static const TabIndex settings = 3;

  static String getName(TabIndex index) {
    switch (index) {
      case home:
        return 'home';
      case player:
        return 'player';
      case learn:
        return 'learn';
      case settings:
        return 'settings';
      default:
        return 'unknown';
    }
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [];
  late final authenticationCubit = getIt<AuthenticationCubit>();
  late final homeCubit = getIt<HomeCubit>();

  //Branch
  StreamSubscription? _branchSubscription;

  @override
  void initState() {
    super.initState();
    //Auth
    if (Utils.getUser() == null) {
      authenticationCubit.ghostLogin();
    }

    //Analytics
    _initAnalytics();

    // Branch listener
    _initBranchListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeCubit.loadHome();
    });

    //TabBar
    tabItems = [
      HomePage(homeCubit: homeCubit),
      HomePage(homeCubit: homeCubit),
      HomePage(homeCubit: homeCubit),
      const SettingsPage(),
    ];
  }

  void _initAnalytics() async {
    try {
      await PosthogService().initialize();
      await BranchService().initialize();
      await HeapService().initialize();
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar Analytics Tools: $e');
      }
    }
  }

  void _initBranchListener() {
    _branchSubscription = BranchService().branchDataStream.listen((data) {
      if (kDebugMode) {
        print('Datos recibidos de Branch: $data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = 167;
    if (defaultTargetPlatform == TargetPlatform.android) {
      height = 137;
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authenticationCubit),
        BlocProvider.value(value: homeCubit),
      ],
      child: GestureDetector(
        child: Scaffold(
          body: Center(
            child: tabItems[_selectedIndex],
          ),
          bottomNavigationBar: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                FlashyTabBar(
                  animationCurve: Curves.linear,
                  selectedIndex: _selectedIndex,
                  backgroundColor:
                      Theme.of(context).scaffoldBackgroundColor,
                  iconSize: 30,
                  showElevation: false,
                  onItemSelected: (index) => setState(() {
                    
                    getIt<AnalyticsService>()
                        .track("tab_bar_item_selected", {
                      "tab_index": TabIndices.getName(index),
                    });

                    HeapService().trackEvent("tab_bar_item_selected", {
                      "tab_index": TabIndices.getName(index),
                    });
                    PosthogService().trackEvent(
                        eventName: "tab_bar_item_selected",
                        properties: {
                          "tab_index": TabIndices.getName(index),
                        });

                    _selectedIndex = index;
                  }),
                  items: [
                    FlashyTabBarItem(
                      icon: SvgPicture.asset(
                        'assets/images/home.svg',
                        colorFilter: ColorFilter.mode(
                          Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .color!,
                          BlendMode.srcIn,
                        ),
                      ),
                      title: Text('Home',
                          style:
                              Theme.of(context).textTheme.bodyMedium),
                    ),
                    FlashyTabBarItem(
                      icon: SvgPicture.asset('assets/images/player.svg',
                          colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color!,
                            BlendMode.srcIn,
                          )),
                      title: Text('Page 2',
                          style:
                              Theme.of(context).textTheme.bodyMedium),
                    ),
                    FlashyTabBarItem(
                      icon: SvgPicture.asset('assets/images/book.svg',
                          colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color!,
                            BlendMode.srcIn,
                          )),
                      title: Text('Page 3',
                          style:
                              Theme.of(context).textTheme.bodyMedium),
                    ),
                    FlashyTabBarItem(
                      icon:
                          SvgPicture.asset('assets/images/settings.svg',
                              colorFilter: ColorFilter.mode(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!,
                                BlendMode.srcIn,
                              )),
                      title: Text(
                        'Settings',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            )
          )  
        )
      )
    );
  }

  @override
  void dispose() {
    _branchSubscription?.cancel();
    super.dispose();
  }
}
