import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

part 'image_comparator_clipper.dart';

part 'widget_size_helper.dart';

class ImageComparator extends StatefulWidget {
  final double? width;
  final double? height;
  final double controlVerticalOffset;
  final double controlLineWidth;
  final double controlHorizontalOffset;
  final Color controlLineColor;
  final Widget? image1;
  final Widget? image2;
  final Widget? controlThumb;

  const ImageComparator({
    super.key,
    this.width,
    this.height,
    this.controlLineColor = Colors.white,
    this.controlLineWidth = 2,
    this.controlThumb,
    this.controlVerticalOffset = 0.5,
    this.controlHorizontalOffset = 0.5,
    this.image1,
    this.image2,
  })  : assert(controlVerticalOffset > -1 && controlVerticalOffset <= 1,
            "thumbPositionOffset must between 0 and 1"),
        assert(controlHorizontalOffset > -1 && controlHorizontalOffset <= 1,
            "controlLineInitialOffset must between 0 and 1");

  @override
  State<ImageComparator> createState() => _ImageComparatorWidgetState();
}

class _ImageComparatorWidgetState extends State<ImageComparator> {
  double controlPointX = 0;
  Size thumbSize = const Size(0, 0);
  double maxWidth = 0;

  @override
  void initState() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) {
          controlPointX = maxWidth * widget.controlHorizontalOffset;
        }
      },
    );
    super.initState();
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
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: widget.image1,
                ),
                ClipPath(
                  clipper: _ImageComparatorClipper(
                    controlPosition: controlPointX,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.image2,
                  ),
                ),
                Positioned(
                  left: controlPointX,
                  bottom: (constraints.maxHeight -
                      (constraints.maxHeight - thumbSize.height) *
                          (widget.controlVerticalOffset)),
                  child: Center(
                    child: Container(
                      width: widget.controlLineWidth,
                      height: constraints.maxHeight,
                      color: widget.controlLineColor,
                    ),
                  ),
                ),
                Positioned(
                  left: controlPointX,
                  top: ((constraints.maxHeight - thumbSize.height) *
                          (widget.controlVerticalOffset)) +
                      thumbSize.height,
                  child: Container(
                    width: widget.controlLineWidth,
                    height: constraints.maxHeight,
                    color: widget.controlLineColor,
                  ),
                ),
                Positioned(
                  left: (controlPointX + (widget.controlLineWidth / 2)) -
                      (thumbSize.width / 2),
                  top: (constraints.maxHeight - thumbSize.height) *
                      (widget.controlVerticalOffset).toDouble(),
                  child: _WidgetSizeHelper(
                    onChange: (Size size) {
                      setState(() {
                        thumbSize = size;
                      });
                    },
                    child: widget.controlThumb ?? const SizedBox(),
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
