import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/widgets/device_module_widget.dart';
import 'package:spark/widgets/metric_modules/metric_oxygen_module_widget.dart';
import 'package:spark/widgets/universal/filter_node.dart';
import 'package:spark/widgets/universal/icon_button_widget.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: themeDarkDeepBackground,
      body: Column(
        children: <Widget>[
          Expanded(child: DashboardBody()),
          DashboardAppBar(),
        ],
      ),
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double deviceListWidth = constraints.maxWidth < 800 ? 71 : 350;
      return Row(
        children: [
          DeviceList(deviceListWidth: deviceListWidth),
          Metrics(),
        ],
      );
    });
  }
}

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool showLogoText = constraints.maxWidth >= 500;

        return Container(
          height: 70,
          color: themeDarkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              LogoSection(showText: showLogoText),
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
      width: showText ? 145 : 50,
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
              "S.P.A.R.K.",
              style: GoogleFonts.varelaRound(
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: themeDarkForeground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: themeDarkSecondaryText,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              "Search...",
              style: GoogleFonts.varelaRound(
                fontWeight: FontWeight.normal,
                color: themeDarkSecondaryText,
                fontSize: 12,
              ),
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
          icon: HugeIcons.strokeRoundedFilter,
          buttonFunction: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.maxFinite,
                        height: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Advanced Filter',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: FilterNode(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close')),
                            )
                          ],
                        ),
                      ),
                    ));
          },
        ),
        const SizedBox(width: 5),
        IconButtonWidget(
          icon: HugeIcons.strokeRoundedAdd01,
          buttonFunction: () {},
        ),
        const SizedBox(width: 5),
        IconButtonWidget(
          icon: HugeIcons.strokeRoundedSettings01,
          buttonFunction: () {},
        ),
        const SizedBox(width: 5),
        IconButtonWidget(
          icon: HugeIcons.strokeRoundedNotification01,
          buttonFunction: () {},
        ),
      ],
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({super.key, required this.deviceListWidth});

  final double deviceListWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          width: deviceListWidth,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: const CustomScrollView(
              physics: BouncingScrollPhysics(), slivers: [DeviceListItems()]),
        ),
      ),
    );
  }
}

class DeviceListItems extends StatelessWidget {
  const DeviceListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final crewEntries = crews.entries.toList();
        if (index >= crewEntries.length) return null;

        final crew = crewEntries[index];
        return _buildCrewSection(crew);
      }, childCount: crews.entries.length),
    );
  }

  Widget _buildCrewSection(MapEntry<String, dynamic> crew) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeviceCrewHeader(crew: crew),
        const SizedBox(height: 5),
        ..._buildMemberModules(crew),
        _buildDivider(),
      ],
    );
  }

  List<Widget> _buildMemberModules(MapEntry<String, dynamic> crew) {
    return [
      for (var i = 0; i < crew.value.entries.length; i++) ...[
        SizedBox(
            width: double.infinity,
            child: DeviceMemberModule(member: crew.value.entries.elementAt(i))),
        if (i < crew.value.entries.length - 1) const SizedBox(height: 5),
      ]
    ];
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: themeDarkBackground,
              borderRadius: BorderRadius.circular(25)),
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: metricsList.length,
            itemBuilder: (BuildContext context, int index) {
              return MetricItem(title: metricsList[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 40);
            },
          ),
        ),
      ),
    );
  }
}

class MetricItem extends StatelessWidget {
  const MetricItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeDarkForeground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: themeDarkDivider,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        title,
                        style: GoogleFonts.varelaRound(
                          fontWeight: FontWeight.bold,
                          color: themeDarkPrimaryText,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: themeDarkDivider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 400, child: MetricOxygenModuleWidget()),
        ],
      ),
    );
  }
}
