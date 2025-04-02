import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/dialogs/custom_dialog.dart';
import 'package:spark/dialogs/dialog_preferences.dart';
import 'package:spark/pages/dashboard/widgets/device_details_widget.dart';
import 'package:spark/pages/dashboard/widgets/device_list_widget.dart';
import 'package:spark/utils/web_socket_manager.dart';
import 'package:spark/widgets/metric_modules/metric_history_module.dart';

import '../../app_providers.dart';
import '../../widgets/common/filter_node.dart';
import '../../widgets/common/icon_button_widget.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: themeDarkBackground,
      body: Column(
        children: <Widget>[
          Expanded(child: DashboardBody()),
          DashboardAppBar(),
        ],
      ),
    );
  }
}

class DashboardBody extends ConsumerWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDeviceWatcher = ref.watch(selectedDeviceProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        color: themeDarkDeepBackground,
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            if (selectedDeviceWatcher != null) {
              return const DeviceDetailsPanel();
            }
            return const DeviceList(
              isFullscreen: true,
            );
          } else {
            return const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                  child: SizedBox(
                    width: 350,
                    child: DeviceList(),
                  ),
                ),
                Expanded(child: DeviceDetailsPanel()),
              ],
            );
          }
        }),
      ),
    );
  }
}

class DashboardAppBar extends ConsumerWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDeviceWatcher = ref.watch(selectedDeviceProvider);
    final selectedDeviceReader = ref.read(selectedDeviceProvider.notifier);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isSmallWidth = constraints.maxWidth < 700;

        return Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              (isSmallWidth && selectedDeviceWatcher != null)
                  ? IconButtonWidget(
                      width: 50,
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      onPressed: () {
                        selectedDeviceReader.clearSelection();
                      },
                    )
                  : LogoSection(showText: !isSmallWidth),
              const SizedBox(width: 20),
              const Spacer(),
              const AppBarActions()
            ],
          ),
        );
      },
    );
  }
}

class LogoSection extends StatelessWidget {
  const LogoSection({super.key, required this.showText});

  final bool showText;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      width: 180,
      decoration: const BoxDecoration(color: Colors.transparent),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            Image.asset("images/SPARK_small.png", height: 50, width: 50),
            const SizedBox(width: 5),
            Text(
              "S . P . A . R . K .",
              style: GoogleFonts.asap(
                fontWeight: FontWeight.w900,
                color: themeDarkPrimaryText,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.only(left: 15, right: 3.5),
      decoration: BoxDecoration(
        color: themeDarkForeground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Text(
                "Search...",
                style: GoogleFonts.asap(
                  fontWeight: FontWeight.normal,
                  color: themeDarkSecondaryText,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          IconButtonWidget(
            height: 35,
            width: 35,
            borderRadius: BorderRadius.circular(5),
            icon: HugeIcons.strokeRoundedFilter,
            iconSize: 20,
            isIdleClear: true,
            onPressed: () {
              showCustomDialog(
                context: context,
                pageBuilder: (_, __, ___) {
                  return const FilterManager();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButtonWidget(
          icon: HugeIcons.strokeRoundedSettings01,
          onPressed: () {
            showCustomDialog(
              context: context,
              pageBuilder: (_, __, ___) {
                return const DialogPreferences();
              },
            );
          },
        ),
        const SizedBox(width: 5),
        IconButtonWidget(
          icon: HugeIcons.strokeRoundedNotification01,
          onPressed: () {},
        ),
      ],
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({super.key, this.isFullscreen = false});

  final bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeDarkBackground,
        borderRadius: BorderRadius.circular(isFullscreen ? 0 : 15),
        border: Border.all(
          width: 1.5,
          color: Colors.white.withValues(alpha: isFullscreen ? 0 : 0.1),
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 20,
            color: Colors.black.withValues(alpha: 0.35),
          ),
        ],
      ),
      child: const Column(
        children: [
          Expanded(child: DeviceListWidget()),
          Padding(
            padding: EdgeInsets.all(5),
            child: SearchBar(),
          ),
        ],
      ),
    );
  }
}

class Metrics extends ConsumerWidget {
  Metrics({
    super.key,
  });

  final metricsList = [
    "Temperature (°C)",
    "Carbon Monoxide (ppm)",
    "PM1 (µg/m³)",
    "PM2.5 (µg/m³)",
    "PM4 (µg/m³)",
    "PM10 (µg/m³)",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(webSocketManagerProvider);

    if (wsState.errorMessage != null) {
      return Column(
        children: [
          Center(
            child: Text(
              wsState.errorMessage!,
              style: GoogleFonts.asap(
                fontWeight: FontWeight.w900,
                color: themeDarkPrimaryText,
                fontSize: 20,
              ),
            ),
          ),
          wsState.isReconnecting ? Text('Attempting to reconnect in 3 seconds.') : SizedBox()
        ],
      );
    }

    if (wsState.isConnecting) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              color: themeDarkPrimaryText,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Connecting to device",
              style: GoogleFonts.asap(
                fontWeight: FontWeight.w900,
                color: themeDarkPrimaryText,
                fontSize: 20,
              ),
            )
          ],
        ),
      );
    }

    if (!wsState.isConnected) {
      return Center(
        child: Text(
          "Select a device",
          style: GoogleFonts.asap(
            fontWeight: FontWeight.w900,
            color: themeDarkPrimaryText,
            fontSize: 20,
          ),
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: themeDarkAccentColourFaded,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'wsState.receivedData.toString(),'
            ),
          ),
        ),
        ListView.separated(
          padding: const EdgeInsets.all(15),
          physics: const BouncingScrollPhysics(),
          itemCount: metricsList.length,
          itemBuilder: (BuildContext context, int index) {
            return MetricItem(title: metricsList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: themeDarkDivider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class MetricItem extends StatelessWidget {
  const MetricItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MetricHistoryModule(metricTitle: title);
  }
}
