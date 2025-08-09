
import 'package:flutter/material.dart';
import 'package:user_profile/packages/app_ui/text_style_extension.dart';

class EmptyPosts extends StatelessWidget {
  const EmptyPosts({
    this.text,
    this.icon = Icons.camera_alt_outlined,
    this.child,
    this.isSliver = true,
    super.key,
  });

  final String? text;
  final IconData icon;
  final Widget? child;
  final bool isSliver;

  Widget empty(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 92,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: context.adaptiveColor, width: 2),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FittedBox(child: Icon(icon)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
           "暂无内容！",
            style: context.headlineSmall,
          ),
          if (child != null) ...[
            const SizedBox(height: 8),
            child!,
          ],
        ]
      );

  @override
  Widget build(BuildContext context) {
    return isSliver
        ? SliverFillRemaining(child: empty(context))
        : empty(context);
  }
}