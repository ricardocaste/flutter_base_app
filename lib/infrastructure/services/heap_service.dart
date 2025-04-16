import 'package:flutter_app/infrastructure/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:heap_flutter_bridge/heap_flutter_bridge.dart';

class HeapService {
  static final HeapService _instance = HeapService._internal();
  factory HeapService() => _instance;
  
  HeapService._internal();

  static const String _envId = Constants.heapEnvId; 

  Future<void> initialize() async {
    try {
      // Configure log level
      if (kDebugMode) {
        await Heap().setLogLevel(HeapLogLevel.debug);
      }
      
      // Start recording
      await Heap().startRecording(_envId);
      
      if (kDebugMode) {
        await _logInitializationInfo();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inicializando Heap: $e');
      }
    }
  }

  Future<void> _logInitializationInfo() async {
    try {
      final userId = await Heap().getUserId() ?? 'unknown';
      final identity = await Heap().getIdentity() ?? '(unidentified)';
      final sessionId = await Heap().fetchSessionId() ?? 'unknown';
      
      if (kDebugMode) {
        print('''
        Heap inicializado con:
        UserId: $userId
        Identity: $identity
        SessionId: $sessionId
      ''');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo información de Heap: $e');
      }
    }
  }

  // Identify user
  Future<void> identifyUser(String userId, {Map<String, dynamic>? properties}) async {
    try {
      await Heap().identify(userId);
      
      if (properties != null) {
        await addUserProperties(properties);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error identificando usuario en Heap: $e');
      }
    }
  }

  // Add user properties
  Future<void> addUserProperties(Map<String, dynamic> properties) async {
    try {
      await Heap().addUserProperties(properties);
    } catch (e) {
      if (kDebugMode) {
        print('Error añadiendo propiedades de usuario en Heap: $e');
      }
    }
  }

  // Track event
  Future<void> trackEvent(String eventName, [Map<String, dynamic>? properties]) async {
    try {
      await Heap().track(eventName, properties ?? {});
    } catch (e) {
      if (kDebugMode) {
        print('Error trackeando evento en Heap: $e');
      }
    }
  }

  // Track purchase
  Future<void> trackPurchase({
    required String productId,
    required double amount,
    String? currency = 'EUR',
    Map<String, dynamic>? additionalProperties,
  }) async {
    try {
      final properties = {
        'product_id': productId,
        'amount': amount,
        'currency': currency,
        ...?additionalProperties,
      };

      await trackEvent('purchase_completed', properties);
    } catch (e) {
      if (kDebugMode) {
        print('Error trackeando compra en Heap: $e');
      }
    }
  }

  // Reset identity
  Future<void> resetIdentity() async {
    try {
      await Heap().resetIdentity();
    } catch (e) {
      if (kDebugMode) {
        print('Error reseteando identidad en Heap: $e');
      }
    }
  }

  // Get current user ID
  Future<String?> getCurrentUserId() async {
    try {
      return await Heap().getUserId();
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo userId de Heap: $e');
      }
      return null;
    }
  }

  // Get current session ID
  Future<String?> getCurrentSessionId() async {
    try {
      return await Heap().fetchSessionId();
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo sessionId de Heap: $e');
      }
      return null;
    }
  }
}