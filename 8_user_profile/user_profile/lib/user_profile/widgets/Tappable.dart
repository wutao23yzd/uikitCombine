import 'package:flutter/material.dart';

enum TappableVariant {

  normal,

  faded
}

enum FadeStrength {
  sm(.2),

  md(.4),

  lg(1);

  const FadeStrength(this.strength);

  final double strength;
}

class Tappable extends StatefulWidget {
  const Tappable({
    required this.child,
    super.key,
    this.padding,
    this.onTap,
    this.fadeStrength,
    this.borderRadius,
    this.backgroundColor,
  }) : variant = TappableVariant.normal;

  const Tappable.faded({
    required this.child,
    super.key,
    this.padding,
    this.onTap,
    this.fadeStrength = FadeStrength.md,
    this.borderRadius,
    this.backgroundColor,
  }) : variant = TappableVariant.faded;

  final TappableVariant variant;

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final GestureTapCallback? onTap;

  final FadeStrength? fadeStrength;

  final BorderRadiusGeometry? borderRadius;

  final Color? backgroundColor;

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> with SingleTickerProviderStateMixin {


  late AnimationController _animationController;
  late Animation<double> _animation;

    @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: widget.fadeStrength?.strength ?? 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget.variant == TappableVariant.faded) {
      _animationController.forward();
    }
  }

  void _handleTapUp(_) {
    if (widget.variant == TappableVariant.faded) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.variant == TappableVariant.faded) {
      _animationController.reverse();
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: widget.backgroundColor
        ),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: widget.child
        ),
      ),
    );

    return widget.variant == TappableVariant.faded
        ? FadeTransition(opacity: _animation, child: child)
        : child;
  }
}