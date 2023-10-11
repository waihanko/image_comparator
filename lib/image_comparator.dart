import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ImageComparatorView extends StatefulWidget {
  final double? width;
  final double? height;
  final double thumbOffset;
  final double controlLineWidth;
  final Color handleLineColor;
  final Widget? image1;
  final Widget? image2;
  final Widget? thumb;

  const ImageComparatorView({
    super.key,
    this.width,
    this.height,
    this.thumbOffset = 0.5,
    this.handleLineColor = Colors.white,
    this.controlLineWidth = 2,
    this.thumb,
    this.image1,
    this.image2,
  }) : assert(thumbOffset > -1 && thumbOffset < 101,
            "controlInitialPosition must between 0 and 100");

  @override
  State<ImageComparatorView> createState() => _ImageComparatorViewState();
}

class _ImageComparatorViewState extends State<ImageComparatorView> {
  double controlPointX = 0.0;
  double maxWidth = 0.0;
  Size thumbSize = const Size(0, 0);

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(
        () {
          if (controlPointX == 0 && widget.width != null) {
            controlPointX = maxWidth * 0.5;
          }else{
            controlPointX = widget.width! * 0.5;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(builder: (context, constraints) {
        maxWidth = constraints.maxWidth;
        return GestureDetector(
          onTapUp: (details) {
            setState(() {
              controlPointX = details.localPosition.dx;
            });
          },
          onHorizontalDragUpdate: (details) {
            double newPositionX = controlPointX + details.delta.dx;
            if (newPositionX >= 0 && newPositionX <= constraints.maxWidth) {
              setState(() {
                controlPointX = newPositionX;
              });
            }
          },
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: widget.image1,
                ),
                ClipPath(
                  clipper:
                      ImageComparatorClipper(controlPosition: controlPointX),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.image2,
                  ),
                ),
                Positioned(
                  left: controlPointX,
                  bottom: (constraints.maxHeight - thumbSize.height) *
                          (widget.thumbOffset)!.toDouble() +
                      thumbSize.height,
                  child: Container(
                    width: 2,
                    height: constraints.maxHeight,
                    color: Colors.red,
                  ),
                ),
                Positioned(
                  left: controlPointX,
                  top: (constraints.maxHeight - thumbSize.height) *
                          (widget.thumbOffset)!.toDouble() +
                      thumbSize.height,
                  child: Container(
                    width: 2,
                    height: constraints.maxHeight,
                    color: Colors.red,
                  ),
                ),
                Positioned(
                  left: (controlPointX + 1) - (thumbSize.width / 2),
                  top: (constraints.maxHeight - thumbSize.height) *
                      (widget.thumbOffset)!.toDouble(),
                  child: WidgetSize(
                    onChange: (Size size) {
                      setState(() {
                        thumbSize = size;
                      });
                    },
                    child: widget.thumb ?? const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const WidgetSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}

class ImageComparatorClipper extends CustomClipper<Path> {
  final double controlPosition;

  ImageComparatorClipper({required this.controlPosition});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(controlPosition, 0); //size.width * 0.25 => variable
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(controlPosition, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
