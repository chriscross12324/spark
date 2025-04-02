import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_providers.dart';
import 'package:spark/dialogs/base_dialog.dart';
import 'package:spark/dialogs/custom_dialog.dart';
import 'package:spark/dialogs/dialog_add_device.dart';
import 'package:spark/dialogs/dialog_add_group.dart';
import 'package:spark/dialogs/dialog_confirm.dart';
import 'package:spark/dialogs/dialog_modify_value.dart';
import 'package:spark/widgets/common/list_separator.dart';
import 'package:spark/widgets/common/segmented_control.dart';
import 'package:spark/widgets/common/setting_switch_list_tile.dart';
import 'package:spark/widgets/common/text_button_widget.dart';

import '../app_constants.dart';
import '../pages/dashboard/widgets/device_list_widget.dart';
import '../widgets/common/icon_button_widget.dart';
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
              showCustomDialog(
                context: context,
                pageBuilder: (_, __, ___) {
                  return const BaseDialog(
                      dialogTitle: 'Connection Successful',
                      dialogContent: SizedBox());
                },
              );
            } else {
              showCustomDialog(
                context: context,
                pageBuilder: (_, __, ___) {
                  return const BaseDialog(
                      dialogTitle: 'Connection Failed',
                      dialogContent: SizedBox());
                },
              );
            }
          });
        } else {
          showCustomDialog(
            context: context,
            pageBuilder: (_, __, ___) {
              return const DialogAddGroup();
            },
          );
        }
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
      data: (deviceGroups) => ListView.separated(
        shrinkWrap: true,
        itemCount: deviceGroups.length,
        itemBuilder: (context, index) {
          final deviceGroup = deviceGroups[index];

          return Container(
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    width: 1.5, color: Colors.white.withValues(alpha: 0.05))),
            padding: EdgeInsets.all(5),
            child: Column(
              spacing: 5,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(5),
                          ),
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Text(
                                "Group Name: ",
                                style: GoogleFonts.asap(
                                  fontWeight: FontWeight.w900,
                                  color: themeDarkPrimaryText,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextButtonWidget(
                                  text: deviceGroup.groupName,
                                  containsPadding: false,
                                  smallBorderRadius: true,
                                  onPressed: () {
                                    showCustomDialog(
                                      context: context,
                                      pageBuilder: (_, __, ___) {
                                        return DialogModifyValue(
                                          currentValue: deviceGroup.groupName,
                                          valueName: 'Group Name',
                                          onValueChanged: (String newValue) {
                                            ref
                                                .read(groupProvider.notifier)
                                                .updateGroup(
                                                    deviceGroup.groupID,
                                                    'groupName',
                                                    newValue);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Row(
                          children: [
                            IconButtonWidget(
                              height: 35,
                              width: 35,
                              icon: HugeIcons.strokeRoundedAdd01,
                              iconSize: 18,
                              isIdleClear: true,
                              borderRadius: BorderRadius.circular(3),
                              onPressed: () {
                                showCustomDialog(
                                  context: context,
                                  pageBuilder: (_, __, ___) {
                                    return DialogAddDevice(
                                        groupID: deviceGroup.groupID);
                                  },
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 20,
                                width: 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color:
                                        Colors.white.withValues(alpha: 0.15)),
                              ),
                            ),
                            IconButtonWidget(
                              height: 35,
                              width: 35,
                              icon: HugeIcons.strokeRoundedDelete02,
                              iconSize: 18,
                              iconColour: Colors.red,
                              colour: Colors.red,
                              isIdleClear: true,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(2.5),
                                topRight: Radius.circular(7.5),
                                bottomLeft: Radius.circular(2.5),
                                bottomRight: Radius.circular(7.5),
                              ),
                              onPressed: () {
                                showCustomDialog(
                                  context: context,
                                  pageBuilder: (_, __, ___) {
                                    return DialogConfirm(
                                      onConfirm: () {
                                        ref
                                            .read(groupProvider.notifier)
                                            .removeGroup(deviceGroup.groupID);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ...deviceGroup.groupDevices.map(
                  (device) => Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              border: Border.all(
                                width: 1.5,
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Call Sign: ",
                                  style: GoogleFonts.asap(
                                    fontWeight: FontWeight.w900,
                                    color: themeDarkPrimaryText,
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: TextButtonWidget(
                                    text: device.deviceID,
                                    containsPadding: false,
                                    smallBorderRadius: false,
                                    onPressed: () {
                                      showCustomDialog(
                                        context: context,
                                        pageBuilder: (_, __, ___) {
                                          return DialogModifyValue(
                                            currentValue: device.deviceID,
                                            valueName: 'Call Sign',
                                            onValueChanged: (String newValue) {
                                              ref
                                                  .read(groupProvider.notifier)
                                                  .updateDevice(
                                                      deviceGroup.groupID,
                                                      device.deviceID,
                                                      'deviceID',
                                                      newValue);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  "Name: ",
                                  style: GoogleFonts.asap(
                                    fontWeight: FontWeight.w900,
                                    color: themeDarkPrimaryText,
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: TextButtonWidget(
                                    text: device.deviceUserName,
                                    containsPadding: false,
                                    smallBorderRadius: true,
                                    onPressed: () {
                                      showCustomDialog(
                                        context: context,
                                        pageBuilder: (_, __, ___) {
                                          return DialogModifyValue(
                                            currentValue: device.deviceUserName,
                                            valueName: 'User\'s Name',
                                            onValueChanged: (String newValue) {
                                              ref
                                                  .read(groupProvider.notifier)
                                                  .updateDevice(
                                                      deviceGroup.groupID,
                                                      device.deviceID,
                                                      'deviceUserName',
                                                      newValue);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: IconButtonWidget(
                              height: 35,
                              width: 35,
                              icon: HugeIcons.strokeRoundedDelete02,
                              iconSize: 18,
                              iconColour: Colors.red,
                              colour: Colors.red,
                              isIdleClear: true,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(2.5),
                                topRight: Radius.circular(7.5),
                                bottomLeft: Radius.circular(2.5),
                                bottomRight: Radius.circular(7.5),
                              ),
                              onPressed: () {
                                showCustomDialog(
                                  context: context,
                                  pageBuilder: (_, __, ___) {
                                    return DialogConfirm(
                                      onConfirm: () {
                                        ref
                                            .read(groupProvider.notifier)
                                            .removeDevice(deviceGroup.groupID,
                                                device.deviceID);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SectionDividerItem();
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
