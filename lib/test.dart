import 'package:flutter/material.dart';

class MirrorMatchImageView extends StatefulWidget {
  final double controlInitialPosition;
  final double controlLineWidth;
  final Gradient controlLineGradient;
  final Color controlViewColor;
  final String? originalImage;
  final String? refinedImage;

  const MirrorMatchImageView({
    super.key,
    this.controlInitialPosition = 50,
    this.controlLineGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.white,
        Colors.white,
      ],
    ),
    this.controlLineWidth = 2,
    this.controlViewColor = Colors.white,
    this.originalImage,
    this.refinedImage,
  }): assert(controlInitialPosition > -1 && controlInitialPosition < 101, "controlInitialPosition must between 0 and 100");

  @override
  State<MirrorMatchImageView> createState() => _MirrorMatchImageViewState();
}

class _MirrorMatchImageViewState extends State<MirrorMatchImageView> {
  double dragPercent = 0;
  Offset controlPosition = const Offset(0.0, 0.0);

  @override
  void initState() {
    dragPercent = widget.controlInitialPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      controlPosition = Offset(constraints.maxWidth * (dragPercent / 100), 0);
      return Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              widget.originalImage ?? "",
              fit: BoxFit.cover,
            ),
          ),
          ClipPath(
            clipper: MirrorImageClipper(controlPosition: (controlPosition.dx)),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                widget.refinedImage ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: getControlPosition(constraints.maxWidth),
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.controlLineGradient,
              ),
              width: widget.controlLineWidth,
              height: constraints.maxHeight,
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackShape: CustomControlView(),
            ),
            child: Slider(
              min: 0.0,
              max: 100.0,
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(
                  widget.controlViewColor.withOpacity(0.2)),
              value: dragPercent,
              thumbColor: widget.controlViewColor,
              onChanged: (value) {
                setState(
                      () {
                    dragPercent = value;
                    controlPosition =
                        Offset(constraints.maxWidth * (dragPercent / 100), 0);
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  double getControlPosition(double maxWidth) {
    if (controlPosition.dx == 0 && dragPercent != 0) {
      return maxWidth * (dragPercent / 100);
    }
    return controlPosition.dx - (widget.controlLineWidth / 2);
  }
}

class CustomControlView extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final trackTop = (parentBox.size.height) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight!);
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