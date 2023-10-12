// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
part of 'image_comparator.dart';

class _WidgetSizeHelper extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const _WidgetSizeHelper({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  State<_WidgetSizeHelper> createState() => _WidgetSizeHelperState();
}

class _WidgetSizeHelperState extends State<_WidgetSizeHelper> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  GlobalKey widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}