import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/app_provider_classes.dart';

class SettingTextFieldListTile extends ConsumerWidget {
  const SettingTextFieldListTile({
    super.key,
    required this.title,
    required this.description,
    required this.stringProvider,
    required this.sharedPreferencesKey,
  });

  final String title;
  final String description;
  final StateNotifierProvider<TypedProvider<String>, String>? stringProvider;
  final String sharedPreferencesKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final stringWatcher = ref.watch(stringProvider);
    //final stringReader = ref.watch(stringProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.asap(
            color: themeDarkSecondaryText,
            fontSize: 16,
            height: 1.0,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: GoogleFonts.asap(
            color: themeDarkDimText,
            fontSize: 12,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 40,
          padding: const EdgeInsets.only(left: 15, right: 3.5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(
                'wss://',
                style: GoogleFonts.asap(
                  fontWeight: FontWeight.bold,
                  color: themeDarkDimText,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: TextField(

                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  keyboardAppearance: Brightness.dark,
                  cursorColor: themeDarkPrimaryText,
                  cursorRadius: const Radius.circular(1),
                  cursorWidth: 2,
                  style: GoogleFonts.asap(
                    fontWeight: FontWeight.bold,
                    color: themeDarkSecondaryText,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'wss://...',
                    hintStyle: GoogleFonts.asap(
                      color: themeDarkDimText,
                    ),
                    //border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
