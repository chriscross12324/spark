import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/providers/dashboard_provider.dart';

class DeviceDetailsWidget extends ConsumerStatefulWidget {
  const DeviceDetailsWidget({super.key});

  @override
  ConsumerState<DeviceDetailsWidget> createState() =>
      _DeviceDetailsWidgetState();
}

class _DeviceDetailsWidgetState extends ConsumerState<DeviceDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedDeviceState = ref.watch(dashboardProvider);
    final stateNotifier = ref.read(dashboardProvider.notifier);

    return selectedDeviceState.selectedMember == null
        ? Center(
            child: Text(
              'Nothing Selected',
              style: GoogleFonts.asap(
                fontWeight: FontWeight.w900,
                color: themeDarkPrimaryText,
                fontSize: 20,
              ),
            ),
          )
        : Center(
            child: Text(
              'Item Selected: ${selectedDeviceState.selectedMember?.id}',
              style: GoogleFonts.asap(
                fontWeight: FontWeight.w900,
                color: themeDarkPrimaryText,
                fontSize: 20,
              ),
            ),
          );
  }
}
