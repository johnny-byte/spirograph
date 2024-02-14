import 'dart:math';
import 'dart:ui';

// import 'package:advance_math/advance_math.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fraction/fraction.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  late final AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    // animation = Tween<double>(begin: 0, end: 0).animate(controller);
    controller.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CurveAnimation(
          animation: controller,
          movements: [
            Movement(1, 100),
            Movement(-5, 1 / 10 * 100),
            Movement(13, 1/20*100),
            // Movement(-9, 100),
          ],
        ),
      ),
    );
  }
}

class Movement {
  final Fraction w;
  final double r;

  Movement(num w, num r)
      : w = w is double ? Fraction.fromDouble(w) : Fraction(w.toInt()),
        r = r.toDouble();
}

class CurveAnimation extends AnimatedWidget {
  final List<Movement> movements;
  final List<Offset> points = [];

  CurveAnimation({
    super.key,
    this.movements = const [],
    required Animation<double> animation,
  }) : super(listenable: animation) {
    _generatePoints();
  }

  Animation<double> get animation => (listenable as Animation<double>);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PainterForCurve(
        progress: animation.value,
        points: points,
      ),
    );
  }

  void _generatePoints() {
    final reducedDenominatorProduct = movements
        .map((e) => e.w)
        .map((e) => e.reduce())
        .map((e) => e.denominator.abs())
        .reduce((lcm, n) => lcm * n ~/ lcm.gcd(n));

    int n = 1000;
    double start = 0;
    double end = 2 * pi * reducedDenominatorProduct;
    double step = (end - start) / n;

    r(t) {
      double x = 0;
      double y = 0;
      for (var movement in movements) {
        x += movement.r * cos(movement.w.toDouble() * t);
        y += movement.r * sin(movement.w.toDouble() * t);
      }
      return Offset(x, y);
    }

    points.addAll([for (var i = 0; i <= n; i++) r(start + i * step)]);
  }
}

class PainterForCurve extends CustomPainter {
  final double progress;
  final List<Offset> points;
  final int nDrawable;

  PainterForCurve({
    super.repaint,
    required this.progress,
    required this.points,
  }) : nDrawable = progress >= 1
            ? points.length
            : max(1, (points.length * progress).toInt());

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final drawablePoints = points.take(nDrawable);

    final path = Path();

    path.moveTo(points.first.dx, points.first.dy);
    for (var point in drawablePoints) {
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paint);
    canvas.drawCircle(drawablePoints.last, 10, paint);
  }

  @override
  bool shouldRepaint(PainterForCurve oldDelegate) {
    // FIXME: implement shouldRepaint
    return nDrawable != oldDelegate.nDrawable;
  }
}
