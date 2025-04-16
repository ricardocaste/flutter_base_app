import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/infrastructure/constants/app_colors.dart';
import 'package:flutter_app/infrastructure/constants/app_text_styles.dart';
import 'package:flutter_app/infrastructure/extensions/contextx.dart';
import 'package:flutter_app/presentation/widgets/decorations.dart';

enum TypeAppBar {
  normal,
  search,
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.title,
    required this.context,
    this.centerTitle = true,
      this.removeLeading = false,
      this.action,
      this.args,
      this.backAction,
      this.isSearchOpen = false,
      this.actions,
      this.type = TypeAppBar.normal,
      this.leadingWidth,
      this.titleSpacing,
      this.bottom,
      this.bottomHeight = 0,
      this.isLeadingCloseIcon = false, this.leading, this.onChanged, this.onTapBackSearch, this.onTapSearch, this.appearSearch, this.controller,});

  const AppBarWidget.search(
      {super.key, required this.onChanged,
      this.title,
      required this.context,
      this.centerTitle = true,
      this.removeLeading = false,
      this.action,
      this.args,
      this.backAction,
      this.actions,
      this.isLeadingCloseIcon = false,
      this.appearSearch = true,
      this.isSearchOpen = false,
      this.onTapBackSearch,
      this.onTapSearch,
      this.leading,
      this.type = TypeAppBar.search,
      this.bottom,
      this.titleSpacing,
      this.bottomHeight = 0,
      this.leadingWidth, this.controller});

  final BuildContext context;
  final String? title;
  final bool centerTitle;
  final bool removeLeading;
  final String? action;
  final Object? args;
  final bool isLeadingCloseIcon;
  final Function? backAction;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double bottomHeight;
  final double? leadingWidth;
  final ValueChanged<String>? onChanged;
  final Function? onTapBackSearch;
  final Function? onTapSearch;
  final double? titleSpacing;
  final TypeAppBar type;
  final bool? isSearchOpen;
  final bool? appearSearch;
  final TextEditingController? controller;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (!isSearchOpen! ? bottomHeight : 0));

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: context.isDark ? Brightness.dark : Brightness.light, // For iOS (dark icons)
      ),
      backgroundColor: Colors.transparent,
      leadingWidth: leadingWidth,
      toolbarHeight: 80,
      titleSpacing: null,
      title: Text(title ?? ''),
      centerTitle: centerTitle,
      titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      leading: removeLeading
          ? Container()
          : leading ??
              IconButton(
                icon: Icon(isLeadingCloseIcon ? Icons.close : Icons.arrow_back, color: Theme.of(context).iconTheme.color,),
                highlightColor: Colors.transparent,
                splashColor: AppColors.acqua_10,
                onPressed: () {
                  if (backAction == null) {
                   Navigator.pop(context);
                  } else {
                    backAction!();
                  }
                },
              ),
      actions: actions != null
          ? actions! + [searchItem(), const SizedBox(width: 16)]
          : <Widget>[
              action != null
                  ? IconButton(
                      icon: const Icon(Icons.list),
                      highlightColor: Colors.transparent,
                      splashColor: AppColors.acqua_10,
                      onPressed: () {
                        Navigator.of(context).pushNamed(action!, arguments: args);
                      },
                    )
                  : Container(),
              searchItem(),
              const SizedBox(width: 16)
            ],
      elevation: 0,
      bottom: bottom,
    );

    switch (type) {
      case TypeAppBar.normal:
        return appbar;
      case TypeAppBar.search:
        if (isSearchOpen!) {
          return AppBar(
            toolbarHeight: 80,
            titleSpacing: titleSpacing,
            title: Container(
              margin: const EdgeInsets.only(right: 10.0),
              alignment: Alignment.center,
              height: 48,
              child: TextField(
                controller: controller,
                cursorHeight: 18,
                cursorWidth: 1,
                cursorColor: Colors.black,
                autofocus: true,
                decoration: Decorations.searchDecoration('Search', controller, onChanged!),
                onChanged: (String value) {
                  onChanged!(value);
                },
                style: AppTextStyles.appBarStyle,
              ),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.acqua_50),
              highlightColor: Colors.transparent,
              splashColor: AppColors.acqua_10,
              onPressed: () {
                onTapBackSearch!();
              },
            ),
            elevation: 0,
          );
        } else {
          return appbar;
        }
      }
  }
  Widget searchItem() {
    return type != TypeAppBar.search
        ? Container()
        : isSearchOpen!
            ? Container()
            : !appearSearch!
                ? Container()
                : IconButton(
                    icon: const Icon(Icons.search, color: AppColors.acqua_50),
                    highlightColor: Colors.transparent,
                    splashColor: AppColors.acqua_10,
                    onPressed: () {
                      onTapSearch!();
                    },
                  );
  }
}
