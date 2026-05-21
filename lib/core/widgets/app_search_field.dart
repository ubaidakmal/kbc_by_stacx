import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search_rounded,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
    );
  }
}
