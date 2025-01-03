import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/pages/dashboard/widgets/device_details_widget.dart';
import 'package:spark/pages/dashboard/widgets/device_list_widget.dart';
import 'package:spark/providers/dashboard_provider.dart';
import 'package:spark/widgets/metric_modules/metric_history_module.dart';

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
    final listState = ref.watch(dashboardProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        color: themeDarkDeepBackground,
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            if (listState.selectedMember != null) {
              return const DeviceDetailsWidget();
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
                Expanded(child: DeviceDetailsWidget()),
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
    final listState = ref.watch(dashboardProvider);
    final stateNotifier = ref.read(dashboardProvider.notifier);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isSmallWidth = constraints.maxWidth < 700;

        return Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              (isSmallWidth && listState.selectedMember != null)
                  ? IconButtonWidget(
                      width: 50,
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      onPressed: () {
                        stateNotifier.selectItem(null);
                      },
                    )
                  : LogoSection(showText: !isSmallWidth),
              const SizedBox(width: 20),
              const Expanded(child: SearchBar()),
              const SizedBox(width: 20),
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
      width: showText ? 180 : 50,
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
    return Center(
      child: Container(
        width: 400,
        height: 50,
        padding: const EdgeInsets.only(left: 15, right: 5),
        decoration: BoxDecoration(
          color: themeDarkForeground,
          borderRadius: BorderRadius.circular(10),
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
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            IconButtonWidget(
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(5),
              icon: HugeIcons.strokeRoundedFilter,
              onPressed: () {
                showDialog(
                    context: context,
                    barrierColor: themeDarkDeepBackground.withOpacity(0.35),
                    builder: (context) => const FilterManager());
              },
            ),
          ],
        ),
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
          icon: HugeIcons.strokeRoundedAdd01,
          onPressed: () {},
        ),
        const SizedBox(width: 5),
        IconButtonWidget(
          icon: HugeIcons.strokeRoundedSettings01,
          onPressed: () {},
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
            width: 2,
            color: Colors.white.withOpacity(isFullscreen ? 0 : 0.15),
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 20,
              color: Colors.black.withOpacity(0.35),
            ),
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const DeviceListWidget(),
    );
  }
}

class Metrics extends StatelessWidget {
  Metrics({
    super.key,
  });

  final metricsList = [
    "Temperature",
    "Humidity",
    "CO2",
    "Particulate",
    "Other 1",
    "Other 2",
    "Other 3",
    "Other 4",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
