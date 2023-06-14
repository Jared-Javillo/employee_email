import 'package:flutter/material.dart';

mixin ErrorPropertiesMixin<T extends StatefulWidget> on State<T> {
  String? _error;
  bool? _isError;

  String? get error => _error;

  bool get isError => _isError ?? false;

  @override
  void initState() {
    _isError = false;
    super.initState();
  }

  void showError(BuildContext context, String? error) {
    if (!isError) {
      if (error?.isNotEmpty ?? false) {
        showModalBottomSheet(
          context: context,
          isDismissible: true,
          barrierColor: Colors.transparent,
          routeSettings: const RouteSettings(
            name: 'error',
          ),
          builder: (context) {
            return Container();
          },
        );
      }
      setState(() {
        _error = error;
        _isError = true;
      });
    }
  }

  void setError(bool isError) {
    setState(() {
      _isError = isError;
    });
  }
}
