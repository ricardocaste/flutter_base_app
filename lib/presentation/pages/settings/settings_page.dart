import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_app/infrastructure/constants/constants.dart';
import 'package:azbox/azbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/infrastructure/constants/app_colors.dart';
import 'package:flutter_app/infrastructure/extensions/contextx.dart';
import 'package:flutter_app/presentation/widgets/app_bar_widget.dart';
import 'package:flutter_app/domain/entities/user.dart' as u;
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  
  String _version = '';

  final int listLength = 7;
  var isSwitched = false;
  u.User? user;

  @override
  void initState() {
    super.initState();
    try {
      _getVersion();
      user = Get.find<u.User>(tag: 'user'); 
    } catch (e) {
      user = null;
    }
  }

  Future<void> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBarWidget(title: "Settings", removeLeading: true, context: context,),
      body: ListView(
      children: [
        _buildSectionHeader('General'),
        
        _buildSwitchTile(
          'Dark Mode',
          context.isDark,
          (value) {
            setState(() {
              context.isDark
                ? AdaptiveTheme.of(context).setLight()
                : AdaptiveTheme.of(context).setDark();
            });
          },
        ),

        _buildSectionHeader('Translation'),

        ListTile(
          title: Text(
            'Language',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: SizedBox(
            width: 120,
            child: LanguagePickerDropdown(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              onValuePicked: (Language language) {
                if (kDebugMode) {
                  print(language.name);
                }
              }
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          minVerticalPadding: 0,
          visualDensity: const VisualDensity(vertical: -4),
        ),
        
        if (user != null)
          _buildSectionHeader('Account'),
        
        if (user != null)
          _buildActionTile('Delete Account', () {
            showShadDialog(
              context: context,
              builder: (context) => ShadDialog.alert(
                title: const Text('Delete Account'),
                description: const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Are you sure to delete this account? this step cannot be undone',
                  ),
                ),
                actions: [
                  ShadButton.outline(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ShadButton(
                    child: const Text('Continue'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            );
          }),
        
        _buildSectionHeader('About'),
        _buildActionTile('Privacy Policy', () async {
        final Uri url = Uri.parse(Constants.privacyPolicyUrl);
        if (!await launchUrl(url)) {
          throw Exception('No se pudo abrir $url');
        }
        }),
        _buildActionTile('Terms of service', () async {
        final Uri url = Uri.parse(Constants.termsOfServiceUrl);
        if (!await launchUrl(url)) {
          throw Exception('No se pudo abrir $url');
        }
        }),
        _buildSimpleTile('Version: $_version', () {}),
      ],
    ));
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.blue,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTile(String title, Function()? onTap) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, Function onTap) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () => onTap(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: -4), 
    );
  }

   void deleteAccount() {
    FirebaseAuth.instance.signOut();
    Get.reset();
    Navigator.of(context).pushNamed('/');
  }
}

 