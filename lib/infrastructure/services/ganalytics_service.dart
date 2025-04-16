import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  factory AnalyticsService() {
    return _singleton;
  }

  AnalyticsService._internal();

  static final AnalyticsService _singleton = AnalyticsService._internal();

  late FirebaseAnalytics analytics;
  late FirebaseAnalyticsObserver observer;

  Future<void> init() async {
    try {
      analytics = FirebaseAnalytics.instance;
      observer = FirebaseAnalyticsObserver(analytics: analytics);
      await analytics.setAnalyticsCollectionEnabled(true);

      if (kDebugMode) {
        print('Analytics inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inicializando Analytics: $e');
      }
    }
  }

  void setUserId(String uid) {
    try {
      analytics.setUserId(id: uid); 
      if (kDebugMode) {
        print('User ID establecido: $uid');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error estableciendo User ID: $e');
      }
    }
  }

  void track(String eventName, [Map<String, Object>? properties]) {
    try {
      if (properties == null || properties.isEmpty) {
        properties = {'_name': eventName};
      }
      analytics.logEvent(name: eventName, parameters: properties);
    } catch (e) {
      if (kDebugMode) {
        print('Error tracking event $eventName: $e');
      }
    }
  }

  void currentScreen() {

  }
}
