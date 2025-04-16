
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_app/data/firebase_options.dart';
import 'package:flutter_app/infrastructure/constants/constants.dart';
import 'package:flutter_app/infrastructure/di/di.dart' as di;
import 'package:flutter_app/presentation/nav/route_generator.dart';
import 'package:flutter_app/presentation/themes.dart';
import 'package:azbox/azbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  OneSignal.Debug.setLogLevel(OSLogLevel.none);
  OneSignal.initialize(Constants.oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);

  // 1. Initialize Firebase first
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Initialize HydratedBloc
   HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // 3. Initialize Azbox
  await Azbox.ensureInitialized(
      apiKey: Constants.kAzboxApiKey, projectId: Constants.kAzboxProjectId);

  // 4. Initialize dependencies (which includes AnalyticsService)
  await di.init();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(Azbox(child: App(savedThemeMode: savedThemeMode)));
}

getApplicationDocumentsDirectory() {
}

class App extends StatelessWidget {
  const App({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) =>
        MaterialApp(
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          darkTheme: darkTheme,
          theme: theme,
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRouter,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale
      )
    );
  }
}