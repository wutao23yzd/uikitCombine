import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:follow_page/app_scaffold.dart';
import 'package:follow_page/follow/bloc/bloc/user_profile_bloc.dart';
import 'package:follow_page/follow/model/User.dart';
import 'package:follow_page/follow/view/Tappable.dart';
import 'package:follow_page/follow/view/user_profile_button.dart';

class UserProfileListTile extends StatefulWidget {
  const UserProfileListTile({
    required this.user,
    required this.follower,
    super.key
  });

  final User user;
  final bool follower;

  @override
  State<UserProfileListTile> createState() => _UserProfileListTileState();
}

class _UserProfileListTileState extends State<UserProfileListTile> {

  late bool _isFollowed = false;

  @override
  Widget build(BuildContext context) {
    final profile = context.select((UserProfileBloc bloc) => bloc.state.user);
    final isMe = widget.user.id == profile.id;
    final isMine = true;

    return Tappable.faded(
      onTap: () {
        
      },
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8
      ),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(widget.user.avatarUrl ?? ""),
            radius: 26,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: context.theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600), 
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.user.username ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ),
                            if (widget.follower)
                              FollowTextButton(wasFollowed: _isFollowed, user: widget.user)
                          ],
                        )
                      ),
                      Text(
                        widget.user.username ?? "",
                        style: context.theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, 
                      )
                    ],
                  )
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     UserActionButton(
                      user: widget.user, 
                      isMe: isMe, 
                      isMine: isMine, 
                      follower: widget.follower, 
                      onTap: () {}, 
                      isFollowed: false
                    ),

                    if (widget.follower) ... [
                      SizedBox(width: 12),
                      Flexible(
                        child: Tappable.faded(
                          onTap: () {},
                          child: Icon(Icons.more_vert)
                        )
                      )
                    ]

                    ],
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }
}


class UserActionButton extends StatelessWidget {
  const UserActionButton({
    required this.user,
    required this.isMe,
    required this.isMine,
    required this.follower,
    required this.onTap,
    required this.isFollowed,
    super.key,
  });


  final User user;
  final bool isMe;
  final bool isMine;
  final bool follower;
  final VoidCallback? onTap;
  final bool isFollowed;

  @override
  Widget build(BuildContext context) {

    const padding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 4
    );

    final textStyle = context.theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600);
    const fadeStrength = FadeStrength.md;

    late final Widget followerRemoveButton = UserProfileButton(
      onTap: onTap,
      label: "移除",
      padding: padding,
      textStyle: textStyle,
      fadeStrength: fadeStrength,
    );

    late final Widget followingButton = UserProfileButton(
      onTap: onTap,
      label: isFollowed ? "关注" : "粉丝",
      padding: padding,
      textStyle: textStyle,
      fadeStrength: fadeStrength,
      color: isFollowed ? null : Color.fromARGB(255, 100, 181, 246),
    );

    final child = switch ((follower, isMine, isMe)) {
      (true, true, false) => followerRemoveButton,
      (true, false, false) => followingButton,
      (false, true, false) => followingButton,
      (false, false, false) => followingButton,
      _ => null,
    };

    return switch (child) {
      null => const SizedBox.shrink(),
      final Widget child => Flexible(flex: 9, child: child),
    };
  }
}

class FollowTextButton extends StatelessWidget {
  const FollowTextButton({
    required this.wasFollowed,
    required this.user,
    super.key
  });

  final bool wasFollowed;
  final User user;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: ' • ',
            style:  context.theme.textTheme.bodyMedium
          ),
          TextSpan(
            text: wasFollowed ? "关注" : "粉丝",
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: wasFollowed ? Color(0xFFFFFFFF) : Color(0xFF3898EC)
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                        
              },
          )
        ]
      )
    );
  }
}