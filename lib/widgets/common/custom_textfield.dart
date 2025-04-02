import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';

class CustomTextField extends ConsumerStatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.description,
    required this.hintText,
    required this.textEditingController,
  });

  final String title;
  final String description;
  final String hintText;
  final TextEditingController textEditingController;

  @override
  ConsumerState<CustomTextField> createState() =>
      _CustomTextFieldState();
}

class _CustomTextFieldState
    extends ConsumerState<CustomTextField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
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
          widget.description,
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
          child: TextField(
            controller: widget.textEditingController,
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
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              hintText: widget.hintText,
              hintStyle: GoogleFonts.asap(
                color: themeDarkDimText,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
