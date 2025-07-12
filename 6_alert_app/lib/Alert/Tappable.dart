import 'package:flutter/material.dart';

enum TappableVariant {
  normal,
  faded,
}

enum FadeStrength {
  sm(0.2),
  md(0.4),
  lg(1.0);

  const FadeStrength(this.opacity);
  final double opacity;
}

class Tappable extends StatefulWidget {
  const Tappable({
    super.key,
    required this.child,
    this.onTap,
  })  : _variant = TappableVariant.normal,
        _fadeStrength = null;

  const Tappable.faded({
    super.key,
    required this.child,
    this.onTap,
    FadeStrength fadeStrength = FadeStrength.md,
  })  : _variant = TappableVariant.faded,
        _fadeStrength = fadeStrength;

  final Widget child;
  final VoidCallback? onTap;
  final TappableVariant _variant;
  final FadeStrength? _fadeStrength;

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 1.0,
      end: widget._fadeStrength?.opacity ?? 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget._variant == TappableVariant.faded) {
      _controller.forward();
    }
  }

  void _handleTapUp(_) {
    if (widget._variant == TappableVariant.faded) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget._variant == TappableVariant.faded) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: widget.child,
    );

    return widget._variant == TappableVariant.faded
        ? FadeTransition(opacity: _opacity, child: child)
        : child;
  }
}
