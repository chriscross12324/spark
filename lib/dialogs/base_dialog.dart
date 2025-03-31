import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';

import 'package:spark/widgets/common/text_button_widget.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    required this.dialogTitle,
    this.dialogHeaderWidget,
    required this.dialogContent,
    this.actionButtonText,
    this.onActionPressed,
    this.closeButtonText = 'Close',
    this.onClosePressed,
  });

  final String dialogTitle;
  final Widget? dialogHeaderWidget;
  final Widget dialogContent;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  final String closeButtonText;
  final VoidCallback? onClosePressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 25,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 700),
        decoration: BoxDecoration(
          color: themeDarkDeepBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  dialogTitle,
                  style: GoogleFonts.asap(
                    fontWeight: FontWeight.w900,
                    color: themeDarkPrimaryText,
                    fontSize: 24,
                  ),
                ),
                if (dialogHeaderWidget != null) dialogHeaderWidget!,
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: dialogContent,
              ),
            ),
            Row(
              children: [
                if (actionButtonText != null)
                  TextButtonWidget(
                    text: actionButtonText!,
                    smallBorderRadius: true,
                    onPressed: () {
                      if (onActionPressed != null) onActionPressed!();
                    },
                  ),
                const Spacer(),
                TextButtonWidget(
                  text: closeButtonText,
                  smallBorderRadius: true,
                  onPressed: () {
                    if (onClosePressed != null) onClosePressed!();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
