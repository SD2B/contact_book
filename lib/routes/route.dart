import 'package:contact_book/core/common_enums.dart';
import 'package:contact_book/core/constants.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:contact_book/view/contacts/add_contacts/add_contact.dart';
import 'package:contact_book/view/contacts/contact_list.dart';
import 'package:contact_book/view/contacts/view_contacts/view_contact.dart';
import 'package:contact_book/view/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter myRoute = GoRouter(
  initialLocation: "/",
  redirectLimit: 3,
  errorBuilder: (context, state) {
    return Scaffold(body: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Unknown pages'), ElevatedButton(onPressed: () => context.go("/"), child: const Text("Back"))])));
  },
  navigatorKey: ConstantData.navigatorKey,
  routes: _buildRoutes(),
);

final Future<bool?> isLoaded = splashLoad();
List<RouteBase> _buildRoutes() {
  return [
    GoRoute(
      path: '/',
      name: '/',
      parentNavigatorKey: ConstantData.navigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation),
            child: child,
          );
        },
        child: FutureBuilder<bool?>(
          future: isLoaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Onboarding();
            }
            return ContactList();
          },
        ),
      ),
      routes: [
        ..._staticRoutes(),
      ],
    ),
  ];
}

List<GoRoute> _staticRoutes() {
  return [
    GoRoute(
      path: RouteEnum.contactList.name,
      name: RouteEnum.contactList.name,
      pageBuilder: (BuildContext context, GoRouterState state) => CustomTransitionPage(
        transitionDuration: Duration(milliseconds: 500),
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation), child: child);
        },
        child: ContactList(),
      ),
    ),
    GoRoute(
      path: RouteEnum.addContact.name,
      name: RouteEnum.addContact.name,
      pageBuilder: (BuildContext context, GoRouterState state) {
        ContactModel contactModel = ContactModel();
        if (state.extra != null) {
          qp(state.extra, "rrrrrrrrrrrrrrrrrrrr");
          contactModel = state.extra as ContactModel;
        }
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 500),
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation), child: child);
          },
          child: AddContact(contactModel: contactModel),
        );
      },
    ),
    GoRoute(
      path: RouteEnum.viewContact.name,
      name: RouteEnum.viewContact.name,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final ContactModel contactModel = state.extra as ContactModel;

        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 500),
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation),
              child: child,
            );
          },
          child: ViewContact(contactModel: contactModel),
        );
      },
    ),
  ];
}

Future<bool> splashLoad() async {
  // await Future.delayed(const Duration(seconds: 3));
  return true;
}
