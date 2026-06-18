import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String title;
  const ProfileSettingsScreen({super.key, required this.title});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingTile(
            Icons.notifications_active_outlined,
            l10n.pushNotifications,
            l10n.pushNotificationsDesc,
            _pushNotifications,
            (v) => setState(() => _pushNotifications = v),
          ),
          _buildSettingTile(
            Icons.email_outlined,
            l10n.emailNotifications,
            l10n.emailNotificationsDesc,
            _emailNotifications,
            (v) => setState(() => _emailNotifications = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricAuth = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.security)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.password),
            title: Text(l10n.changePassword),
            trailing: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: Text(l10n.biometricAuth),
            trailing: Switch(
              value: _biometricAuth,
              onChanged: (v) => setState(() => _biometricAuth = v),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.devices),
            title: Text(l10n.activeDevices),
            trailing: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpCenter)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: Text(l10n.liveChat),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.question_answer_outlined),
            title: Text(l10n.faqs),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_outlined),
            title: Text(l10n.contactUs),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
