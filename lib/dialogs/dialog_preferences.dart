import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:spark/app_providers.dart';
import 'package:spark/dialogs/base_dialog.dart';
import 'package:spark/widgets/common/list_separator.dart';
import 'package:spark/widgets/common/segmented_control.dart';
import 'package:spark/widgets/common/setting_switch_list_tile.dart';

import '../app_constants.dart';
import '../widgets/common/setting_textfield_list_tile.dart';

class DialogPreferences extends ConsumerStatefulWidget {
  const DialogPreferences({super.key});

  @override
  ConsumerState<DialogPreferences> createState() => _DialogPreferencesState();
}

class _DialogPreferencesState extends ConsumerState<DialogPreferences> {
  Tabs selectedTab = Tabs.general;
  final Map<Tabs, String> tabsMap = {
    Tabs.general: "General",
    Tabs.devices: "Devices"
  };

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      dialogTitle: 'Preferences',
      dialogHeaderWidget: SegmentedControl<Tabs>(
        options: tabsMap,
        selectedValue: selectedTab,
        onChanged: (Tabs newSelectedTab) {
          setState(() {
            selectedTab = newSelectedTab;
          });
        },
      ),
      actionButtonText: 'Test API',
      onActionPressed: () {
        testApiAccessibility(ref.read(settingAPIEndpoint)).then((isAccessible) {
          if (isAccessible) {
            showGeneralDialog(
              context: context,
              barrierColor: themeDarkDeepBackground.withValues(alpha: 0.35),
              barrierDismissible: false,
              transitionDuration: const Duration(milliseconds: 150),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return const BaseDialog(dialogTitle: 'Connection Successful', dialogContent: SizedBox());
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                );

                return FadeTransition(
                  opacity: curvedAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0)
                        .animate(curvedAnimation),
                    child: child,
                  ),
                );
              },
            );
          } else {
            showGeneralDialog(
              context: context,
              barrierColor: themeDarkDeepBackground.withValues(alpha: 0.35),
              barrierDismissible: false,
              transitionDuration: const Duration(milliseconds: 150),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return const BaseDialog(dialogTitle: 'Connection Failed', dialogContent: SizedBox());
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                );

                return FadeTransition(
                  opacity: curvedAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0)
                        .animate(curvedAnimation),
                    child: child,
                  ),
                );
              },
            );
          }
        });
      },
      dialogContent: Column(
        children: [
          if (selectedTab == Tabs.general) ...sectionGeneral(),
          if (selectedTab == Tabs.devices) const SectionDevices(),
        ],
      ),
    );
  }
}

List<Widget> sectionGeneral() {
  return [
    SettingTextFieldListTile(
      title: 'API Base',
      description: 'Enter the base URL of the SPARK API (e.g., findthefrontier.ca). Don\'t include http:// or https://; just the domain. We’ll take care of the rest.',
      stringProvider: settingAPIEndpoint,
      sharedPreferencesKey: 'settingAPIEndpoint',
    ),
    const ListSeparator(),
    CustomSwitchListTile(
      title: 'Display Moving Average',
      description:
          'Displays another line on the Metric graphs to show the average values over time.',
      boolProvider: settingDisplayAverage,
      sharedPreferencesKey: 'settingDisplayAverage',
    ),
    const ListSeparator(),
    CustomSwitchListTile(
      title: 'Display Device Status',
      description:
      'Displays device status for each device in the device list.',
      boolProvider: settingDisplayDeviceStatus,
      sharedPreferencesKey: 'settingDisplayDeviceStatus',
    ),
  ];
}



class SectionDevices extends StatelessWidget {
  const SectionDevices({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<bool> testApiAccessibility(String baseUrl) async {
  try {
    print('Pinging: $baseUrl/status');
    final response = await http.get(Uri.parse("https://$baseUrl/status"));

    if (response.statusCode == 200) {
      //final data = jsonDecode(response.body);
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}

enum Tabs { general, devices }
