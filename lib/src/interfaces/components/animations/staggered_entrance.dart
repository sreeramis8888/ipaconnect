import 'package:flutter/widgets.dart';

enum SlideFrom { left, right, top, bottom, none }

class _StartupStaggerScope extends InheritedWidget {
  final AnimationController controller;
  final double itemDelayFactor;
  final double itemSpan;
  final Curve curve;

  const _StartupStaggerScope({
    required this.controller,
    required this.itemDelayFactor,
    required this.itemSpan,
    required this.curve,
    required super.child,
  });

  static _StartupStaggerScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_StartupStaggerScope>();
  }

  @override
  bool updateShouldNotify(covariant _StartupStaggerScope oldWidget) {
    return oldWidget.controller != controller ||
        oldWidget.itemDelayFactor != itemDelayFactor ||
        oldWidget.itemSpan != itemSpan ||
        oldWidget.curve != curve;
  }
}

class StartupStagger extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration initialDelay;
  final bool autoPlay;
  final double itemDelayFactor;
  final double itemSpan;
  final Curve curve;

  const StartupStagger({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 900),
    this.initialDelay = Duration.zero,
    this.autoPlay = true,
    this.itemDelayFactor = 0.08,
    this.itemSpan = 0.45,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<StartupStagger> createState() => _StartupStaggerState();
}

class _StartupStaggerState extends State<StartupStagger>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || _started) return;
        _started = true;
        if (widget.initialDelay > Duration.zero) {
          await Future<void>.delayed(widget.initialDelay);
        }
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StartupStaggerScope(
      controller: _controller,
      itemDelayFactor: widget.itemDelayFactor,
      itemSpan: widget.itemSpan,
      curve: widget.curve,
      child: widget.child,
    );
  }
}

class StaggerItem extends StatelessWidget {
  final int order;
  final SlideFrom from;
  final double offset;
  final Widget child;

  const StaggerItem({
    super.key,
    required this.order,
    required this.child,
    this.from = SlideFrom.bottom,
    this.offset = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _StartupStaggerScope.of(context);
    if (scope == null) return child;

    final double start = (order * scope.itemDelayFactor).clamp(0.0, 1.0);
    final double end = (start + scope.itemSpan).clamp(0.0, 1.0);
    final curved = CurvedAnimation(
      parent: scope.controller,
      curve: Interval(start, end, curve: scope.curve),
    );

    Offset begin;
    switch (from) {
      case SlideFrom.left:
        begin = Offset(-offset, 0);
        break;
      case SlideFrom.right:
        begin = Offset(offset, 0);
        break;
      case SlideFrom.top:
        begin = Offset(0, -offset);
        break;
      case SlideFrom.bottom:
        begin = Offset(0, offset);
        break;
      case SlideFrom.none:
        begin = Offset.zero;
        break;
    }

    return FadeTransition(
      opacity: curved,
      child: begin == Offset.zero
          ? child
          : SlideTransition(
              position: Tween<Offset>(begin: begin, end: Offset.zero)
                  .animate(curved),
              child: child,
            ),
    );
  }
}


