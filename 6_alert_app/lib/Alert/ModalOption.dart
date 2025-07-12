
import 'package:flutter/material.dart';

typedef BuildContextCallback = void Function(BuildContext context);

class ModalOption {
  // 操作项的名称
  final String? name;
  // 操作项名称的颜色
  final Color? nameColor;
  // 自定义图标Widget
  final Widget? icon;
  // 如果不自定义Widget，则使用IconData
  final IconData? iconData;
  // 更复杂的子组件（可替代 name + icon）
  final Widget? child;
  // 当弹窗选择“取消”时调用的回调
  final BuildContextCallback? noAction;
  // 弹窗的标题
  final String? actionTitle;
  // 弹窗的主体内容
  final String? actionContent;
  // 弹窗中“取消”按钮的文字
  final String? actionNoText;
  // 弹窗中“确认”按钮的文字
  final String? actionYesText;
  // 是否为危险操作
  final bool distractive;

  ModalOption({
    this.name,
    this.nameColor,
    this.icon,
    this.iconData,
    this.child,
    VoidCallback? onTap,
    this.noAction,
    this.actionTitle,
    this.actionContent,
    this.actionNoText,
    this.actionYesText,
    this.distractive = false,
  }) : _onTap = onTap;

  final VoidCallback? _onTap;

  void onTap(BuildContext context) => _onTap?.call();

  Color? get distractiveColor => distractive ? Colors.red : null;

  ModalOption copyWith({
    String? name,
    Color? nameColor,
    Widget? icon,
    IconData? iconData,
    Widget? child,
    VoidCallback? onTap,
    BuildContextCallback? noAction,
    String? actionTitle,
    String? actionContent,
    String? actionNoText,
    String? actionYesText,
    bool? distractive,
  }) {
    return ModalOption(
      name: name ?? this.name,
      nameColor: nameColor ?? this.nameColor,
      icon: icon ?? this.icon,
      iconData: iconData ?? this.iconData,
      child: child ?? this.child,
      onTap: onTap ?? _onTap,
      noAction: noAction ?? this.noAction,
      actionTitle: actionTitle ?? this.actionTitle,
      actionContent: actionContent ?? this.actionContent,
      actionNoText: actionNoText ?? this.actionNoText,
      actionYesText: actionYesText ?? this.actionYesText,
      distractive: distractive ?? this.distractive,
    );
  }

}
