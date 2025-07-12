import 'package:alert_app/Alert/ModalOption.dart';
import 'package:alert_app/Alert/Tappable.dart';
import 'package:alert_app/Alert/show_dialog.dart';
import 'package:alert_app/selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: '弹窗相关'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                _showDialog();
              },
               child: Text('安卓系统Dialog弹窗')
            ),
            OutlinedButton(
              onPressed: () {
                _showCupertinoDialog();
              },
               child: Text('苹果系统Dialog弹窗')
            ),
            
            OutlinedButton(
              onPressed: () {
                _changeLanguage();
              },
                child: Text('系统SimpleDialog弹窗')
            ),

            OutlinedButton(
              onPressed: () {
                _showBottomSheet();
              },
                child: Text('安卓系统底部弹窗')
            ),

            OutlinedButton(
              onPressed: () {
                _showCupertinoBottomSheet();
              },
              child: Text('苹果风格底部弹窗')
            ),

            MeidaOptionsButton(),

            SettingsButton(),

            ImagePreviewButton()
          ],
        ),
      )
    );
  }

Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('弹窗标题'),
          content: const Text('这是一个弹窗内容。'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCupertinoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('弹窗标题'),
          content: const Text('这是一个弹窗内容。'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeLanguage() async {
    int? result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('选择语言'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: const Text('中文'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 2);
              },
              child: const Text('English'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      // 根据返回的结果进行相应的处理
      if (result == 1) {
        print('选择了中文');
      } else if (result == 2) {
        print('选择了英文');
      }
    }
  }

  Future<void> _showBottomSheet() async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          ListTile(
            title: const Center(child: Text('选项 1')),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Center(child: Text('选项 2')),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            title: const Center(child: Text('取消', style: TextStyle(color: Colors.red))),
            onTap: () => Navigator.pop(context),
          ),
        ],
      );
      },
    );
  }


  Future<void> _showCupertinoBottomSheet() async {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      showDragHandle: false,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('选择操作'),
          message: const Text('请选择一个选项'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('选项 1'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('选项 2'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
        );;
      },
    );
  }
}

class MeidaOptionsButton extends StatelessWidget {
  const MeidaOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
    onPressed: () {
      context.showListOptionsModal(
        title: "新建",
        options: createMediaModalOptions(
          context: context,
          reelLabel: "视频秀",
          postLabel: "动态",
          storyLabel: "故事",
          goTo: (route, {extra}) {
            Navigator.pop(context);
          },
          enableStory: true,
        ),
      ).then((option) {
        if (option != null) {
           void onTap() => option.onTap(context);
            onTap.call();
        }
      });
    },
    child: Text('自定义选项弹窗')
  );
  }

List<ModalOption> createMediaModalOptions({
  required String reelLabel,
  required String postLabel,
  required String storyLabel,
  required BuildContext context,
  required void Function(String route, {Object? extra}) goTo,
  required bool enableStory,
  ValueSetter<String>? onStoryCreated,
}) =>
    <ModalOption>[
      ModalOption(
        name: reelLabel,
        iconData: Icons.video_collection_outlined,
        onTap: () => goTo('create-post', extra: true),
      ),
      ModalOption(
        name: postLabel,
        iconData: Icons.outbox_outlined,
        onTap: () => goTo('create-post'),
      ),
      if (enableStory)
        ModalOption(
          name: storyLabel,
          iconData: Icons.cameraswitch_outlined,
          onTap: () => goTo('create-stories', extra: onStoryCreated),
        ),
    ];
}


class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
    onPressed: () {
      context.showListOptionsModal(
        options: [
          ModalOption(child: const LocaleModalOption()),
          ModalOption(child: const ThemeSelectorModalOption()),
          ModalOption(child: const LogoutModalOption()),
        ],
      ).then((option) {
        if (option == null) return;
        void onTap() => option.onTap(context);
        onTap.call();
      });
    },
    child: Text('设置选项弹窗')
  );
  }
}

class LogoutModalOption extends StatelessWidget {
  const LogoutModalOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () {
        Navigator.pop(context);
      },
      child: ListTile(
        title: Text(
          '登出',
          style: Theme.of(context).textTheme.bodyLarge?.apply(color: Colors.red),
        ),
        leading: const Icon(Icons.logout, color: Colors.red),
      ),
    );
  }
}


class ImagePreviewButton extends StatelessWidget {
  const ImagePreviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
    onPressed: () {
      context.showImagePreview('https://picsum.photos/id/237/300/200');
      
    },
    child: Text('预览图片弹窗')
  );
  }
}