import 'package:codepan/extensions/context.dart';
import 'package:codepan/resources/dimensions.dart';
import 'package:codepan/utils/debouncer.dart';
import 'package:codepan/widgets/text.dart';
import 'package:flutter/material.dart';

class ErrorModalSheet extends StatefulWidget {
  final VoidCallback? onDismiss;
  final String? error;

  const ErrorModalSheet({
    super.key,
    this.error,
    this.onDismiss,
  });

  @override
  State<ErrorModalSheet> createState() => _ErrorModalSheetState();
}

class _ErrorModalSheetState extends State<ErrorModalSheet> {
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 3000);
    _debouncer.run(() {
      if (mounted) {
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    _debouncer.cancel();
    widget.onDismiss?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimension.of(context);
    final t = Theme.of(context);
    return GestureDetector(
      child: PanText(
        text: widget.error,
        fontSize: d.at(12),
        fontColor: Colors.white,
        textAlign: TextAlign.center,
        padding: EdgeInsets.all(d.at(10)),
        background: t.errorColor,
      ),
      onTap: () => context.pop(),
    );
  }
}
