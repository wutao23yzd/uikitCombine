
import 'package:flutter/material.dart';
import 'package:reel_views/packages/app_ui/app_theme.dart';

class VerticalGroup extends StatelessWidget {
  const VerticalGroup({
    this.icon,
    this.child,
    this.iconColor,
    this.size,
    this.withStatistic = true,
    this.statisticCount = 0,
    super.key
  });

  final IconData? icon;
  final Widget? child;
  final Color? iconColor;
  final double? size;
  final bool withStatistic;
  final int? statisticCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child ?? Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: size,
        ),
        
        if (withStatistic) ... [
          const SizedBox(height: 4),
          Text(
            '$statisticCount',
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFFFFFF)
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ]
      ],
    );
  }
}