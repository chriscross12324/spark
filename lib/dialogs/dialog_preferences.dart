import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark/app_providers.dart';
import 'package:spark/widgets/common/base_dialog.dart';
import 'package:spark/widgets/common/list_separator.dart';
import 'package:spark/widgets/common/segmented_control.dart';
import 'package:spark/widgets/common/setting_switch_list_tile.dart';

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
    const SettingTextFieldListTile(
      title: 'API Endpoint',
      description: 'The URL where the SPARK API can be accessed.',
      stringProvider: null,
      sharedPreferencesKey: 'sharedPreferencesKey',
    ),
    const ListSeparator(),
    CustomSwitchListTile(
      title: 'Display Moving Average',
      description:
          'Displays another line on the Metric graphs to show the average values over time.',
      boolProvider: settingDisplayAverage,
      sharedPreferencesKey: 'settingDisplayAverage',
      disabled: true,
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

enum Tabs { general, devices }
