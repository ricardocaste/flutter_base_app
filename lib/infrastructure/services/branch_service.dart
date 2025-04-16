import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:uuid/uuid.dart';

class BranchService {
  static final BranchService _instance = BranchService._internal();
  
  factory BranchService() => _instance;
  
  BranchService._internal();

  StreamSubscription<Map>? _streamSubscription;
  final _controllerData = StreamController<String>.broadcast();
  
  // Getters
  Stream<String> get branchDataStream => _controllerData.stream;

  Future<void> initialize() async {
    await FlutterBranchSdk.init(
      enableLogging: true,
      branchAttributionLevel: BranchAttributionLevel.FULL
    );
    //FlutterBranchSdk.setConsumerProtectionAttributionLevel(BranchAttributionLevel.FULL);
    _listenDynamicLinks();
    //FlutterBranchSdk.validateSDKIntegration();
  }

  void _listenDynamicLinks() {
    _streamSubscription = FlutterBranchSdk.listSession().listen((data) {
      _controllerData.sink.add(data.toString());
      
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        // Process deep link data
        final linkData = {
          //'title': data['$og_title'],
          'custom_string': data['custom_string'],
          'custom_number': data['custom_number'],
          'custom_date': data['custom_date_created'],
        };
        
        // You can emit the processed data or handle it as needed
        _handleDeepLinkData(linkData);
      }
    }, onError: (error) {
      if (kDebugMode) {
        print('Branch Session Error: ${error.toString()}');
      }
    });
  }

  void registerView(String viewName) {
    //FlutterBranchSdk.registerView(buo: viewName);
  }

  Future<String> generateShortLink({
    required String title,
    required String description,
    Map<String, dynamic>? customData,
  }) async {
    final buo = _createBranchUniversalObject(
      title: title,
      description: description,
      customData: customData,
    );

    final lp = BranchLinkProperties(
      channel: 'app',
      feature: 'sharing',
      stage: 'new share',
      campaign: 'content sharing'
    );

    final response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );

    if (response.success) {
      return response.result;
    } else {
      throw Exception('Error generando link: ${response.errorMessage}');
    }
  }

  BranchUniversalObject _createBranchUniversalObject({
    required String title,
    required String description,
    Map<String, dynamic>? customData,
  }) {
    final canonicalIdentifier = const Uuid().v4();

    final metadata = BranchContentMetaData();
    customData?.forEach((key, value) {
      metadata.addCustomMetadata(key, value);
    });

    return BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch_$canonicalIdentifier',
      title: title,
      contentDescription: description,
      contentMetadata: metadata,
      keywords: ['app', 'content'],
      publiclyIndex: true,
      locallyIndex: true,
    );
  }

  void _handleDeepLinkData(Map<String, dynamic> linkData) {
    // Implement the logic to handle the deep link data
    if (kDebugMode) {
      print('Deep Link Data Received: $linkData');
    }
  }

  Future<void> dispose() async {
    await _streamSubscription?.cancel();
    await _controllerData.close();
  }

  void trackingEvents(String title, String description, Map<String, dynamic> customData, BranchStandardEvent event) {
    BranchEvent eventStandard = BranchEvent.standardEvent(event);
    final buo =_createBranchUniversalObject(title: title, description: description, customData: customData);
    FlutterBranchSdk.trackContent(buo: [buo], branchEvent: eventStandard);
  }

  void login (String userId) {
    FlutterBranchSdk.setIdentity(userId);
  }

  void logout() {
    FlutterBranchSdk.logout();
  }
}