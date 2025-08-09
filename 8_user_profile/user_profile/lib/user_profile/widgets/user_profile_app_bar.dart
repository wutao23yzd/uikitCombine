
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_profile/app/generated/assets.gen.dart';
import 'package:user_profile/packages/app_ui/text_style_extension.dart';
import 'package:user_profile/user_profile/bloc/user_profile_bloc.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    final user = context.select((UserProfileBloc b) => b.state.user);

    return SliverPadding(
      padding: const EdgeInsets.only(right: 12),
      sliver: SliverAppBar(
        centerTitle: false,
        pinned: !ModalRoute.of(context)!.isFirst,
        floating: ModalRoute.of(context)!.isFirst,
        title: Row(
          children: [
            Flexible(
              flex: 12,
              child: Text(
                "${user.name}",
                style: context.titleLarge?.copyWith(
                  fontWeight:  FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Assets.lib.assets.icons.verifiedUser.svg(
                width: 18,
                height: 18
              ),
            )
          ],

        ),

        actions: [],
      ),
    );
  }
}