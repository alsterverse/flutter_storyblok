import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/colors.dart';
import 'package:example/snackbar.dart';
import 'package:flutter/material.dart';

class FormSectionWidget extends StatelessWidget {
  const FormSectionWidget(this.blok, {super.key});

  final bloks.FormSection blok;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (blok.backgroundColor) {
      bloks.Colors.primary => AppColors.primary,
      bloks.Colors.secondary => AppColors.secondary,
      bloks.Colors.white => AppColors.white,
      bloks.Colors.light => AppColors.light,
      bloks.Colors.medium => AppColors.medium,
      bloks.Colors.dark => AppColors.black,
      bloks.Colors.unknown => AppColors.primary,
    };

    final textColor = switch (blok.textColor) {
      bloks.FormSectionTextColorOption.light => AppColors.white,
      bloks.FormSectionTextColorOption.dark => AppColors.black,
      bloks.FormSectionTextColorOption.unknown => AppColors.white,
    };

    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(blok.headline ?? "", style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: textColor)),
            const SizedBox(height: 8),
            if (blok.lead != null && blok.lead!.isNotEmpty) ...[
              Text(blok.lead ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor)),
              const SizedBox(height: 32),
            ],
            switch (blok.form) {
              bloks.FormSectionFormOption.contact => throw UnimplementedError(),
              bloks.FormSectionFormOption.newsletter => Column(
                  children: [
                    Text("Sign up for our newsletter",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: textColor)),
                    const SizedBox(height: 16),
                    TextField(
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Your email",
                        contentPadding: const EdgeInsets.all(16),
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: textColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: textColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: textColor),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                      ),
                    ),
                  ],
                ),
              bloks.FormSectionFormOption.unknown => throw UnimplementedError(),
            },
            const SizedBox(height: 16),
            BlockButton(
                blokButton: blok.button!,
                onPressed: () {
                  showSnackbar(context, "Thank you!");
                }),
          ],
        ),
      ),
    );
  }
}
