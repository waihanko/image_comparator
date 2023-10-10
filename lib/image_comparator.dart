import 'package:flutter/material.dart';

class ImageComparatorView extends StatefulWidget {
  final double? width;
  final double? height;
  final double? thumbOffset;
  final double controlInitialPosition;
  final double controlLineWidth;
  final Color controlLineColor;
  final Color thumbColor;
  final Widget? image1;
  final Widget? image2;

  const ImageComparatorView({
    super.key,
    this.width,
    this.thumbOffset = 0.5,
    this.height,
    this.controlInitialPosition = 50,
    this.controlLineColor = Colors.white,
    this.controlLineWidth = 2,
    this.thumbColor = Colors.white,
    this.image1,
    this.image2,
  }): assert(controlInitialPosition > -1 && controlInitialPosition < 101, "controlInitialPosition must between 0 and 100");

  @override
  State<ImageComparatorView> createState() => _ImageComparatorViewState();
}

class _ImageComparatorViewState extends State<ImageComparatorView> {
  double controlPointX = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) =>
            GestureDetector(
              onTapUp: (details) {
                double tapX = details.localPosition.dx;
                //
                // // Get the total width of the widget.
                // double widgetWidth = ;
                //
                // // Calculate the horizontal percentage.
                // double horizontalPercent = (constraints.maxWidth) * 100.0;
                setState(() {
                  controlPointX = tapX;
                });
              },
          onHorizontalDragUpdate: (details) {
            // Calculate the new position of the control point within the container.
            double newPositionX = controlPointX + details.delta.dx;

            // Ensure the control point stays within the container bounds.
            if (newPositionX >= 0 && newPositionX <= constraints.maxWidth - 20.0) {
              setState(() {
                controlPointX = newPositionX;
              });
            }
          },
          child: Container(
            width: constraints.maxWidth,
            height: 300.0,
            color: Colors.blue,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: controlPointX,
                  top: 140.0,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}




class MirrorImageClipper extends CustomClipper<Path> {
  final double controlPosition;

  MirrorImageClipper({required this.controlPosition});

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