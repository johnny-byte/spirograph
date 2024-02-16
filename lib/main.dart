import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fraction/fraction.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

final listOfMovements = [
  [
    CircleMovement(1, 100),
    CircleMovement(1, 27 / 20 * 100),
    CircleMovement(4, 19 / 20 * 100),
    CircleMovement(-5, 11 / 10 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-9, 1 / 20 * 100),
    CircleMovement(10, 21 / 20 * 100),
    // CircleMovement(-5, 11 / 10 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-1, 27 / 10 * 100),
    CircleMovement(-3, 17 / 20 * 100),
    CircleMovement(4, 3 / 4 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(9, 17 / 20 * 100),
    CircleMovement(-4, 29 / 20 * 100),
    CircleMovement(2, 61 / 20 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-4, 11 / 10 * 100),
    CircleMovement(-2, 19 / 10 * 100),
    CircleMovement(4, 4 / 5 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-7, 11 / 15 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-7, 1 / 2 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-3, 3 / 10 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-5, 1 / 10 * 100),
    CircleMovement(13, 1 / 20 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-3, 7 / 20 * 100),
    CircleMovement(6, 1 / 4 * 100),
    CircleMovement(-12, 1 / 10 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-5, 1 * 100),
    CircleMovement(7, 17 / 20 * 100),
    // CircleMovement(4, 4 / 5 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-8, 1 * 100),
    CircleMovement(10, 11 / 10 * 100),
    CircleMovement(1, 3 / 5 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-11, 1 * 100),
    CircleMovement(9, 23 / 20 * 100),
    // CircleMovement(1, 3/5 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-5, 1 * 100),
    CircleMovement(4, 1 * 100),
    // CircleMovement(1, 3/5 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-15, 1 * 100),
    CircleMovement(-2, 1 * 100),
    CircleMovement(14, 11 / 10 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-1, 1 * 100),
    CircleMovement(-12, 1 * 100),
    CircleMovement(11, 1 * 100),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(-1, 11 / 10 * 100),
    CircleMovement(-2, 37 / 20 * 100),
    CircleMovement(-5, 3 / 2 * 100),
  ],
  [
    CircleMovement(1, 50),
    CircleMovement(10, 19 / 20 * 50),
    CircleMovement(-8, 13 / 10 * 50),
    CircleMovement(4, 5 * 50),
  ],
  [
    CircleMovement(1, 100),
    CircleMovement(3, 1 * 100),
    CircleMovement(2, 1 * 100),
    CircleMovement(-5, 19 / 20 * 100),
  ],
  [
    CircleMovement(1, 50),
    CircleMovement(1, 27 / 20 * 50),
    CircleMovement(4, 19 / 20 * 50),
    CircleMovement(-5, 11 / 10 * 50),
  ],
  [
    CircleMovement(1, 50),
    CircleMovement(10, 1 * 50),
    CircleMovement(-5, 1 * 50),
    CircleMovement(-5, 7 / 4 * 50),
  ],
];

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            for (var (n, movemnts) in listOfMovements.indexed)
              ListTile(
                title: Center(child: Text('Example #${n + 1}')),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PageWithCurve(
                        title: Text('Example #${n + 1}'),
                        movements: movemnts,
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}

class PageWithCurve extends StatefulWidget {
  final Widget title;
  final List<CircleMovement> movements;
  const PageWithCurve(
      {super.key, required this.movements, required this.title});

  @override
  State<PageWithCurve> createState() => _PageWithCurveState();
}

class _PageWithCurveState extends State<PageWithCurve>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.title),
      body: Center(
        child: CurveAnimation(
          animation: controller,
          movements: widget.movements,
        ),
      ),
    );
  }
}

class CircleMovement {
  // Угловая частота
  final Fraction w;
  // Радиус окружности
  final double r;

  CircleMovement(num w, num r)
      : w = w is double ? Fraction.fromDouble(w) : Fraction(w.toInt()),
        r = r.toDouble();
}

class CurveAnimation extends AnimatedWidget {
  final List<CircleMovement> movements;
  final List<Offset> points = [];

  CurveAnimation({
    super.key,
    this.movements = const [],
    required Animation<double> animation,
  }) : super(listenable: animation) {
    // FIXME генерировать не сразу все точки
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
    // Вычисляем наименьший общий период
    final reducedDenominatorProduct = movements
        .map((e) => e.w)
        .map((e) => e.reduce())
        .map((e) => e.denominator.abs())
        .reduce((lcm, n) => lcm * n ~/ lcm.gcd(n));

    //FIXME вынести n в конструктор
    int n = 1000;
    double start = 0;
    double end = 2 * pi * reducedDenominatorProduct;
    double step = (end - start) / n;

    r(t) {
      double x = 0;
      double y = 0;

      // Складываем движения по окружностям
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

  // количество точек для отрисовки
  final int _nDrawablePoints;

  PainterForCurve({
    super.repaint,
    required this.progress,
    required this.points,
  }) : _nDrawablePoints = progress >= 1
            ? points.length
            : max(1, (points.length * progress).toInt());

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final drawablePoints = points.take(_nDrawablePoints);

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
    return _nDrawablePoints != oldDelegate._nDrawablePoints;
  }
}
