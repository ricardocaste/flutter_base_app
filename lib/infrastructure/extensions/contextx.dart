import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  // Returns the MediaQuery
  MediaQueryData get mq => MediaQuery.of(this);
  /// Returns same as MediaQuery.of(context).size
  Size get sizePx => mq.size;

  /// Returns same as MediaQuery.of(context).size.width
  double get widthPx => sizePx.width;

  /// Returns same as MediaQuery.of(context).height
  double get heightPx => sizePx.height;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
