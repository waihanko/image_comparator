part of 'image_comparator.dart';

class _ImageComparatorClipper extends CustomClipper<Path> {
  final double controlPosition;

  _ImageComparatorClipper({required this.controlPosition});

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
