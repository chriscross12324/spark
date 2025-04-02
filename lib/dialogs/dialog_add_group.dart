import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_providers.dart';
import 'package:spark/widgets/common/custom_textfield.dart';

import '../app_constants.dart';
import '../widgets/common/text_button_widget.dart';

class DialogAddGroup extends ConsumerWidget {
  const DialogAddGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = TextEditingController();

    return Dialog(
      elevation: 25,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
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
            AutoSizeText(
              'Add Group',
              style: GoogleFonts.asap(
                fontWeight: FontWeight.w900,
                color: themeDarkPrimaryText,
                fontSize: 24,
              ),
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                title: 'Group Name',
                description:
                    'The name that will display at the top of each device group.',
                hintText: 'Group Name',
                textEditingController: textEditingController,
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButtonWidget(
                  text: 'Cancel',
                  smallBorderRadius: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButtonWidget(
                  text: 'Add',
                  smallBorderRadius: true,
                  onPressed: () {
                    if (textEditingController.text.isNotEmpty) {
                      ref
                          .read(groupProvider.notifier)
                          .addGroup(textEditingController.text);
                      Navigator.of(context).pop();
                    }
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
