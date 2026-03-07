import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get navigator => navigatorKey.currentState;

  BuildContext? get context => navigatorKey.currentContext;

  Future<T?>? pushNamed<T>(String routeName, {Object? arguments}) {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?>? pushReplacementNamed<T, TO>(String routeName, {Object? arguments}) {
    return navigator?.pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    navigator?.pop<T>(result);
  }

  Future<T?>? pushNamedAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return navigator?.pushNamedAndRemoveUntil<T>(routeName, predicate, arguments: arguments);
  }
}
