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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CurveAnimation(animation: controller),
      ),
    );
  }
}

class CurveAnimation extends AnimatedWidget {
  final List<Offset> points = [];

  CurveAnimation({super.key, required Animation<double> animation})
      : super(listenable: animation) {
    final rs = [
      100,
      1 * 100,
      11 / 10 * 100,
      3 / 5 * 100,
    ];

    final ws = [
      Fraction(1, 1),
      Fraction(-8, 1),
      Fraction(10, 1),
      Fraction(1, 1),
    ];

    final reducedDenominatorProduct = ws
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
      for (var i = 0; i < ws.length; i++) {
        x += rs[i] * cos(ws[i].toDouble() * t);
        y += rs[i] * sin(ws[i].toDouble() * t);
      }
      return Offset(x, y);
    }

    points.addAll([for (var i = 0; i <= n; i++) r(start + i * step)]);
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

    // //TODO check if every w Fraction > 0
    // final rs = [
    //   100,
    //   1 / 10 * 100,
    //   1 / 20 * 100,
    //   // 0 / 4 * 100,
    // ];

    // final ws = [
    //   Fraction(1, 1),
    //   Fraction(-5, 1),
    //   Fraction(13, 1),
    //   // Fraction(-9, 1),
    // ];

    // //TODO cool animation with this parameters
    // // final rs = [
    // //   100,
    // //   3 / 10 * 100,
    // //   1 / 20 * 100,
    // //   0 / 4 * 100,
    // // ];

    // // final ws = [
    // //   Fraction(1,1),
    // //   Fraction(-3, 1),
    // //   Fraction(13, 1),
    // //   Fraction(-9, 1),
    // // ];

    // final reducedDenominatorProduct = ws
    //     .map((e) => e.reduce())
    //     .map((e) => e.denominator.abs())
    //     .reduce((lcm, n) => lcm * n ~/ lcm.gcd(n));

    // int numenatorProduct = ws.fold(1, (a, b) => a * b.numerator.abs());

    // int specialLCM = ws
    //     .map((e) => numenatorProduct ~/ e.numerator.abs() * e.denominator.abs())
    //     .reduce((lcm, n) => lcm * n ~/ lcm.gcd(n));

    // int k = specialLCM *
    //     ws.first.numerator ~/
    //     (numenatorProduct * ws.first.denominator);

    // print(k);
    // int n = 1000;
    // double start = 0;
    // //FIXME k != 1
    // // double end = 2 * pi * 1 / ws.first.toDouble() * progress;
    // double end = 2 * pi * reducedDenominatorProduct * progress;
    // double step = (end - start) / n;

    // r(t) {
    //   double x = 0;
    //   double y = 0;
    //   for (var i = 0; i < ws.length; i++) {
    //     x += rs[i] * cos(ws[i].toDouble() * t);
    //     y += rs[i] * sin(ws[i].toDouble() * t);
    //   }
    //   return Offset(x, y);
    // }

    // final points = [for (var i = 0; i <= n; i++) r(start + i * step)];

    // print("3.gcd(-3)=${3.gcd(-3)}");

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

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter>
    with SingleTickerProviderStateMixin {
  var _radius = 100.0;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );

    Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizer'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: CustomPaint(
                foregroundPainter: PointPainter(_radius, animation.value),
                painter: CirclePainter(_radius),
                child: Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Size'),
            ),
            Slider(
              value: _radius,
              min: 10.0,
              max: MediaQuery.of(context).size.width / 2,
              onChanged: (value) {
                setState(() {
                  _radius = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// FOR PAINTING THE CIRCLE
class CirclePainter extends CustomPainter {
  final double radius;
  CirclePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.purpleAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    ));
    canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(100, 100),
          Offset(200, 300),
          Offset(300, 300),
        ],
        paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// FOR PAINTING THE TRACKING POINT
class PointPainter extends CustomPainter {
  final double radius;
  final double radians;
  PointPainter(this.radius, this.radians);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var pointPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var innerCirclePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final textSpan = TextSpan(
      text:
          "(${(radius * math.cos(radians)).round()}, ${(radius * math.sin(radians)).round()})",
      style: TextStyle(color: Colors.black, fontSize: 16),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 100,
    );

    var path = Path();

    Offset center = Offset(size.width / 2, size.height / 2);

    path.moveTo(center.dx, center.dy);

    Offset pointOnCircle = Offset(
      radius * math.cos(radians) + center.dx,
      radius * math.sin(radians) + center.dy,
    );

    // For showing the point moving on the circle
    canvas.drawCircle(pointOnCircle, 10, pointPaint);

    // For drawing the inner circle
    // if (math.cos(radians) < 0.0) {
    //   canvas.drawCircle(center, -radius * math.cos(radians), innerCirclePaint);
    //   textPainter.paint(
    //     canvas,
    //     pointOnCircle + Offset(-100, 10),
    //   );
    // } else {
    //   canvas.drawCircle(center, radius * math.cos(radians), innerCirclePaint);
    //   textPainter.paint(
    //     canvas,
    //     pointOnCircle + Offset(10, 10),
    //   );
    // }

    // path.lineTo(pointOnCircle.dx, pointOnCircle.dy);
    // path.lineTo(pointOnCircle.dx, center.dy);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
