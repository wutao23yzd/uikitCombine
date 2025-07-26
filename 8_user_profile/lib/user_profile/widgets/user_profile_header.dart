
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_profile/app/generated/assets.gen.dart';
import 'package:user_profile/packages/app_ui/app_colors.dart';
import 'package:user_profile/packages/app_ui/text_style_extension.dart';
import 'package:user_profile/user_profile/bloc/user_profile_bloc.dart';
import 'package:user_profile/user_profile/widgets/Tappable.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProfileBloc b) => b.state.user);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  foregroundImage: Assets.lib.assets.images.tony.provider(),
                  radius: 35,
                  backgroundColor: Colors.transparent, // 透明背景，让图片保持原色
                ),
                SizedBox(width: 12),
                Expanded(
                  child: UserProfileStatisticsCounts(),
                )
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${user.fullName}',
                style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Flexible(flex: 3, child: UserProfileButton(label: '编辑资料')),
                const Flexible(flex: 3, child: UserProfileButton(label: '分享资料')),
                const Flexible(
                  child: UserProfileButton(
                    label: "", 
                    child: Icon(Icons.person_add_rounded,
                    size: 20,
                    )
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UserProfileStatisticsCounts extends StatelessWidget {
  const UserProfileStatisticsCounts({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCount =
        context.select((UserProfileBloc bloc) => bloc.state.postsCount);
    final followersCount =
        context.select((UserProfileBloc bloc) => bloc.state.followersCount);
    final followingsCount =
        context.select((UserProfileBloc bloc) => bloc.state.followingsCount);
    return Row(
      children: [
        Expanded(
          child: UserProfileStatistic(
            name: '动态',
            value: postsCount,
          ),
        ),
        Expanded(
          child: UserProfileStatistic(
            name: '粉丝',
            value: followersCount,
          ),
        ),
        Expanded(
          child: UserProfileStatistic(
            name: '关注',
            value: followingsCount,
          ),
        ),
      ],
    );
  }
}

class UserProfileStatistic extends StatelessWidget {
  const UserProfileStatistic({
    required this.name,
    required this.value,
    super.key
  });

  final String name;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value',
          style: context.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          name,
          style: context.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis
        )
      ],
    );
  }
}


class UserProfileButton extends StatelessWidget {
  const UserProfileButton({
    required this.label,
    this.child,
    super.key
  });

  final String label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {

    final effectiveColor = context.customReversedAdaptiveColor(
          light: AppColors.brightGrey,
          dark: AppColors.emphasizeDarkGrey,
        );

    return DefaultTextStyle(
    style: context.labelLarge!, 
    child: Tappable.faded(
      fadeStrength: FadeStrength.sm,
      borderRadius: BorderRadius.circular(6),
      backgroundColor: effectiveColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Align(
          child: child ?? Text(
            label,
            style: context.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
    )
    );
  }
}