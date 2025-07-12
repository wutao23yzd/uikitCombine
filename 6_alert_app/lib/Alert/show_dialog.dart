
import 'package:alert_app/Alert/AppButton.dart';
import 'package:alert_app/Alert/ModalOption.dart';
import 'package:alert_app/Alert/Tappable.dart';
import 'package:flutter/material.dart';

extension DialogExtension on BuildContext {

  Future<T?> showAdaptiveDialog<T>({
    String? content,
    String? title,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
    Widget Function(BuildContext)? builder,
    TextStyle? titleTextStyle,
  }) =>
      showDialog<T>(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: builder ??
            (context) {
              return AlertDialog.adaptive(
                actionsAlignment: MainAxisAlignment.end,
                title: Text(title!),
                titleTextStyle: titleTextStyle,
                content: content == null ? null : Text(content),
                actions: actions,
              );
            },
      );
 
  Future<T?> showBottomModal<T>({
    Widget Function(BuildContext context)? builder,
    String? title,
    Color? titleColor,
    Widget? content,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? border,
    bool rounded = true,
    bool isDismissible = true,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool useSafeArea = true,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet(context: this,
        shape: border ??
            (!rounded
                ? null
                : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  )),
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useSafeArea: useSafeArea,
        isScrollControlled: isScrollControlled,
        useRootNavigator: true,
        builder: builder ??
            (BuildContext context) {
              
              return Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: titleColor),
                      ),
                      const Divider(),
                    ],
                    content!,
                  ],
                ),
              );
            });
  }

  Future<ModalOption?> showListOptionsModal({
    required List<ModalOption> options,
    String? title,
  }) =>
      showBottomModal<ModalOption>(
        isScrollControlled: true,
        title: title,
        content: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options
                  .map(
                    (option) =>
                        option.child ??
                        Tappable.faded(
                          onTap: () {
                            option.onTap(this);
                          },
                          child: ListTile(
                            title: option.name == null
                                ? null
                                : Text(
                                    option.name!,
                                    style: Theme.of(this).textTheme.bodyLarge?.copyWith(
                                      color: option.nameColor ??
                                          option.distractiveColor,
                                    ),
                                  ),
                            leading:
                                option.icon == null && option.iconData == null
                                    ? null
                                    : option.icon ??
                                        Icon(
                                          option.iconData,
                                          color: option.distractiveColor,
                                        ),
                          ),
                        ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

   Future<void> showImagePreview(String imageUrl) => showDialog<void>(
        context: this,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: Color(0x00000000),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
          );
        },
      );
}