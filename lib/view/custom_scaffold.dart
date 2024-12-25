import 'package:contact_book/core/colors.dart';
import 'package:contact_book/core/common_enums.dart';
import 'package:contact_book/view/common_widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool? enableBack;
  final bool isClose;
  final String? appBarTitle;
  final bool isHome;
  final Function? onBackCalled;
  final Widget? trailingWidget;
  final PreferredSizeWidget? appBar;

  const CustomScaffold(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.enableBack,
      this.isClose = false,
      this.appBarTitle,
      this.isHome = false,
      this.onBackCalled,
      this.trailingWidget,
      this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ?? const Color.fromARGB(255, 215, 242, 252),
      appBar: appBar ??
          (enableBack == true
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: CustomIconButton(
                      onTap: () {
                        GoRouter.of(context).pop();
                        onBackCalled?.call();
                      },
                      buttonColor: Colors.transparent,
                      icon: isClose ? Icons.close_rounded : Icons.arrow_back,
                      iconColor: ColorCode.colorList(context).secondary,
                    ),
                  ),
                  actions: [trailingWidget ?? SizedBox.shrink()],
                  title: (appBarTitle?.isEmpty == true || appBarTitle == null)
                      ? SizedBox.shrink()
                      : Text(
                          "$appBarTitle",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: ColorCode.colorList(context).secondary,
                              ),
                        ),
                )
              : null),
      body: SafeArea(child: child),
      floatingActionButton: isHome == false
          ? SizedBox.shrink()
          : Card(
              elevation: 5,
              shape: CircleBorder(),
              child: CustomIconButton(
                buttonSize: 55,
                buttonColor: ColorCode.colorList(context).middlePrimary,
                icon: Icons.add,
                iconColor: Colors.white,
                iconSize: 30,
                onTap: () {
                  context.pushNamed(RouteEnum.addContact.name);
                },
              ),
            ),
    );
  }
}
