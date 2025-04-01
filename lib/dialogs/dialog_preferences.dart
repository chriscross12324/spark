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
      actionButtonText: selectedTab == Tabs.general ? 'Test API' : 'Add Group',
      onActionPressed: () {
        if (selectedTab == Tabs.general) {
          testApiAccessibility(ref.read(settingAPIEndpoint))
              .then((isAccessible) {
            if (isAccessible) {
              showGeneralDialog(
                context: context,
                barrierColor: themeDarkDeepBackground.withValues(alpha: 0.35),
                barrierDismissible: false,
                transitionDuration: const Duration(milliseconds: 150),
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return const BaseDialog(
                      dialogTitle: 'Connection Successful',
                      dialogContent: SizedBox());
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
                  return const BaseDialog(
                      dialogTitle: 'Connection Failed',
                      dialogContent: SizedBox());
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
        } else {
          showDialog(
            context: context,
            builder: (context) {
              final textEditingController = TextEditingController();
              return AlertDialog(
                title: Text('Add Group'),
                content: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (textEditingController.text.isNotEmpty) {
                        ref
                            .read(groupProvider.notifier)
                            .addGroup(textEditingController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        }
      },
      dialogContent: Column(
        children: [
          if (selectedTab == Tabs.general) ...sectionGeneral(),
          if (selectedTab == Tabs.devices) SectionDevices(),
        ],
      ),
    );
  }
}

List<Widget> sectionGeneral() {
  return [
    SettingTextFieldListTile(
      title: 'API Base',
      description:
          'Enter the base URL of the SPARK API (e.g., findthefrontier.ca). Don\'t include http:// or https://; just the domain. We’ll take care of the rest.',
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
      description: 'Displays device status for each device in the device list.',
      boolProvider: settingDisplayDeviceStatus,
      sharedPreferencesKey: 'settingDisplayDeviceStatus',
    ),
  ];
}

class SectionDevices extends ConsumerWidget {
  const SectionDevices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDeviceGroups = ref.watch(groupProvider);

    return asyncDeviceGroups.when(
      data: (deviceGroups) => ListView.builder(
        shrinkWrap: true,
        itemCount: deviceGroups.length,
        itemBuilder: (context, index) {
          final deviceGroup = deviceGroups[index];

          return Card(
            child: ExpansionTile(
              title: Text(deviceGroup.groupName),
              subtitle: Text('${deviceGroup.groupDevices.length} devices'),
              trailing: IconButton(
                onPressed: () => ref
                    .read(groupProvider.notifier)
                    .removeGroup(deviceGroup.groupID),
                icon: Icon(Icons.delete),
              ),
              children: [
                ...deviceGroup.groupDevices.map(
                  (device) => ListTile(
                    title: Text(device.deviceUserName),
                    trailing: IconButton(
                      onPressed: () => ref
                          .read(groupProvider.notifier)
                          .removeDevice(deviceGroup.groupID, device.deviceID),
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final deviceIdEditingController =
                            TextEditingController();
                        final deviceUserNameEditingController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Add Device'),
                          content: Column(
                            children: [
                              TextField(
                                controller: deviceIdEditingController,
                                decoration: InputDecoration(
                                  labelText: 'Device ID',
                                ),
                              ),
                              TextField(
                                controller: deviceUserNameEditingController,
                                decoration: InputDecoration(
                                  labelText: 'Device Name',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (deviceUserNameEditingController
                                        .text.isNotEmpty &&
                                    deviceIdEditingController.text.isNotEmpty) {
                                  ref.read(groupProvider.notifier).addDevice(
                                      deviceGroup.groupID,
                                      deviceIdEditingController.text,
                                      deviceUserNameEditingController.text);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Add Device'),
                ),
              ],
            ),
          );
        },
      ),
      error: (e, _) => Container(
        height: 200,
        width: double.infinity,
        child: Center(
          child: Text('Error'),
        ),
      ),
      loading: () => Container(
        height: 200,
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
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
