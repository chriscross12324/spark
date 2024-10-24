import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/widgets/universal/icon_button_widget.dart';
import 'package:spark/app_constants.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  double _deviceListWidth = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeDarkDeepBackground,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  _deviceListWidth = constraints.maxWidth < 800 ? 75 : 350;

                  return Row(
                    children: [
                      DeviceList(deviceListWidth: _deviceListWidth),
                      const Metrics(),
                    ],
                  );
                },
              ),
            ),
          ),
          AppBar(),
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: themeDarkBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              children: [
                Image.asset(
                  "images/SPARK_small.png",
                  height: 50,
                  width: 50,
                ),
                if (constraints.maxWidth >= 450) ... [
                  const SizedBox(width: 5),
                  Text(
                    "S.P.A.R.K.",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: themeDarkPrimaryText,
                      fontSize: 20,
                    ),
                  ),
                ],
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 400,
                      height: 50,
                      decoration: BoxDecoration(
                          color: themeDarkForeground,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedSearch01,
                              color: themeDarkSecondaryText,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
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
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButtonWidget(
                  icon: HugeIcons.strokeRoundedAdd01,
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButtonWidget(
                  icon: HugeIcons.strokeRoundedSettings01,
                ),
                const SizedBox(width: 5),
                IconButtonWidget(
                  icon: HugeIcons.strokeRoundedNotification01,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DeviceList extends StatefulWidget {
  const DeviceList({
    super.key,
    required double deviceListWidth,
  }) : _deviceListWidth = deviceListWidth;

  final double _deviceListWidth;

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<Widget> widgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var crew in crews.entries) {
      widgets.add(SliverToBoxAdapter(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            String firstChars =
                crew.key.split(' ').map((word) => word[0]).join();

            return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: constraints.maxWidth < 300
                    ? SizedBox(
                        height: 55,
                        width: 55,
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xfff7744f),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "${firstChars}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: themeDarkSecondaryText,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0xfff7744f),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "${crew.key}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeDarkPrimaryText,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ));
          },
        ),
      ));
      widgets.add(SliverToBoxAdapter(
        child: SizedBox(
          height: 10,
        ),
      ));

      for (var member in crew.value.entries) {
        widgets.add(
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: themeDarkBackground,
                  child: SizedBox(
                    height: 75,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                color: themeDarkForeground,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "1",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: themeDarkDimText,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${member.key}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeDarkPrimaryText,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "${member.value['lastName']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeDarkDimText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );

        widgets.add(SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ));
      }
      widgets.add(SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: themeDarkDimText.withOpacity(0.05),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ));
      widgets.add(SliverToBoxAdapter(
        child: SizedBox(
          height: 10,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          height: double.infinity,
          width: widget._deviceListWidth,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            slivers: [...widgets],
          ),
        ),
      ),
    );
  }
}

class Metrics extends StatelessWidget {
  const Metrics({
    super.key,
  });

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
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: 8,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  color: themeDarkForeground,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
