import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
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
      backgroundColor: themeDarkBackground,
      body: Column(
        children: <Widget>[
          Container(
            height: 60,
            width: double.infinity,
            color: themeDarkForeground,
            child: Row(
              children: [
                Text("S.P.A.R.K."),
                Expanded(child: Container()),
                Icon(FluentIcons.settings_20_regular),
                Icon(FluentIcons.service_bell_20_regular),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  _deviceListWidth = constraints.maxWidth < 800 ? 75 : 350;

                  return Row(
                    children: [
                      AnimatedContainer(
                        height: double.infinity,
                        width: _deviceListWidth,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        child: SmoothListView.separated(
                          physics: const BouncingScrollPhysics(),
                          smoothScroll: false,
                          itemCount: 100,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: themeDarkForeground,
                              child: ListTile(
                                title: Text("Device: $index", maxLines: 1),
                                subtitle: Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                  maxLines: 2,
                                ),
                                textColor: themeDarkPrimaryText,
                                isThreeLine: true,
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 5);
                          },
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: double.infinity,
                          width: 4,
                          decoration: BoxDecoration(
                            color: themeDarkDivider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const Metrics(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
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
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
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
    );
  }
}
