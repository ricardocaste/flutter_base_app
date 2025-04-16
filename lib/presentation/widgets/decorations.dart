import 'package:flutter/material.dart';
import 'package:flutter_app/infrastructure/constants/app_colors.dart';
import 'package:flutter_app/infrastructure/constants/app_text_styles.dart';

class Decorations {

  static InputDecoration searchDecoration(String hintText, TextEditingController? controller, ValueChanged<String> onChanged) {
    return InputDecoration(
        labelStyle: AppTextStyles.anotationStyle,
        hintStyle: AppTextStyles.titleStyle,
        hintText: hintText,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: AppColors.gray_50)),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: AppColors.gray_50)),
        suffixIcon: IconButton(
          highlightColor: Colors.transparent,
          splashColor: AppColors.acqua_10,
          onPressed: () {
            if (controller != null) {
              controller.clear();
            }
            onChanged('');
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.acqua_50,
          ),
        )
    );
  }
}
