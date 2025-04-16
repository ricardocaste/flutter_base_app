import 'package:flutter_app/infrastructure/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PosthogService {
  static final PosthogService _instance = PosthogService._internal();
  factory PosthogService() => _instance;
  
  PosthogService._internal();

  static const String _apiKey = Constants.posthogApiKey;
  static const String _host = Constants.posthogHost; 

  Future<void> initialize() async {
    try {
      final config = PostHogConfig(_apiKey);
      
      // General configuration
      config.host = _host;
      config.debug = kDebugMode;
      config.captureApplicationLifecycleEvents = true;
      
      // Session Replay configuration
      config.sessionReplay = true;
      config.sessionReplayConfig.maskAllTexts = true;
      config.sessionReplayConfig.maskAllImages = false;
      config.sessionReplayConfig.throttleDelay = const Duration(milliseconds: 1000);
      
      // Events sending configuration
      config.flushAt = 10; 
      config.flushInterval = const Duration(seconds: 30);

      await Posthog().setup(config);
      
      if (kDebugMode) {
        print('PostHog inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inicializando PostHog: $e');
      }
    }
  }

  // User identification
  Future<void> identifyUser({
    required String userId,
    Map<String, dynamic>? userProperties,
    Map<String, dynamic>? userPropertiesSetOnce,
  }) async {
    try {
      await Posthog().identify(
        userId: userId,
        userProperties: userProperties?.cast<String, Object>(),
        userPropertiesSetOnce: userPropertiesSetOnce?.cast<String, Object>(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error identificando usuario: $e');
      }
    }
  }

  // Event tracking
  Future<void> trackEvent({
    required String eventName,
    Map<String, dynamic>? properties,
  }) async {
    try {
      await Posthog().capture(
        eventName: eventName,
        properties: properties?.cast<String, Object>(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error trackeando evento: $e');
      }
    }
  }

  // Screen tracking
  Future<void> trackScreen({
    required String screenName,
    Map<String, dynamic>? properties,
  }) async {
    try {
      await Posthog().screen(
        screenName: screenName,
        properties: properties?.cast<String, Object>(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error trackeando pantalla: $e');
      }
    }
  }

  // Purchase tracking
  Future<void> trackPurchase({
    required String productId,
    required double price,
    String? currency = 'EUR',
    Map<String, dynamic>? additionalProperties,
  }) async {
    try {
      final properties = {
        'product_id': productId,
        'price': price,
        'currency': currency,
        ...?additionalProperties,
      };

      await trackEvent(
        eventName: 'purchase_completed',
        properties: properties,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error trackeando compra: $e');
      }
    }
  }

  // Feature Flags
  Future<bool> isFeatureEnabled(String flagKey) async {
    try {
      return await Posthog().isFeatureEnabled(flagKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error comprobando feature flag: $e');
      }
      return false;
    }
  }

  // Groups
  Future<void> setGroup({
    required String groupType,
    required String groupKey,
    Map<String, dynamic>? groupProperties,
  }) async {
    try {
      await Posthog().group(
        groupType: groupType,
        groupKey: groupKey,
        groupProperties: groupProperties?.map((key, value) => MapEntry(key, value as Object)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error estableciendo grupo: $e');
      }
    }
  }

  // Reset user
  Future<void> reset() async {
    try {
      await Posthog().reset();
    } catch (e) {
      if (kDebugMode) {
        print('Error reseteando usuario: $e');
      }
    }
  }

  // Force events sending
  Future<void> flush() async {
    try {
      await Posthog().flush();
    } catch (e) {
      if (kDebugMode) {
        print('Error forzando envío de eventos: $e');
      }
    }
  }
}