import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/managers/navigation.dart';
import '../app/translations/translations.dart';

class AppLifeCycleListenerWidget extends StatefulWidget {
  const AppLifeCycleListenerWidget({super.key, required this.child});

  final Widget child;

  @override
  State<AppLifeCycleListenerWidget> createState() =>
      _AppLifeCycleListenerWidgetState();
}

class _AppLifeCycleListenerWidgetState
    extends State<AppLifeCycleListenerWidget> {
  late AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();

    _listener = AppLifecycleListener(
      onStateChange: _onStateChange,
      onRestart: _onRestart,
    );
  }

  _onStateChange(AppLifecycleState state) {
    if (kDebugMode) {
      print(state.toString());
    }
  }

  _onRestart() {
    Navigators().showMessage(LocaleKeys.app_log_on_restart.tr());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
}