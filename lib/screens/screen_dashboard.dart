import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/widgets/device_module_widget.dart';
import 'package:spark/widgets/metric_modules/metric_oxygen_module_widget.dart';
import 'package:spark/widgets/metric_modules/metric_oxygen_module_widget_backup.dart';
import 'package:spark/widgets/universal/icon_button_widget.dart';
import 'package:spark/app_constants.dart';

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
          Expanded(
            child: DashboardBody()
          ),
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
      double deviceListWidth = constraints.maxWidth < 800 ? 75 : 350;
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
            const Text(
              "S.P.A.R.K.",
              style: TextStyle(
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
        child: const Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: themeDarkSecondaryText,
              size: 18,
            ),
            SizedBox(width: 5),
            Text(
              "Search...",
              style: TextStyle(
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
        borderRadius: BorderRadius.circular(25),
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
    List<Widget> widgets = [];

    for (var crew in crews.entries) {
      widgets.add(DeviceCrewHeader(crew: crew, expanded: true));
      widgets.add(const SizedBox(height: 10));
      for (var member in crew.value.entries) {
        widgets.add(DeviceMemberModule(member: member, expanded: true));
        widgets.add(const SizedBox(height: 10));
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: themeDarkDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
      widgets.add(const SizedBox(height: 10));
    }

    return SliverList(delegate: SliverChildListDelegate(widgets));
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
              color: themeDarkBackground, borderRadius: BorderRadius.circular(25)),
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
    return Column(
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: themeDarkDivider,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
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
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeDarkForeground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const MetricOxygenModuleWidget(),
        ),
      ],
    );
  }
}
