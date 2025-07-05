import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone_app/app/bloc/app_bloc.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/widgets/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('主页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 这里可以添加设置按钮的逻辑
            },
          ),
        ],
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // 触发登出
              context.read<AppBloc>().add(AppLogoutRequested());
            },
            child: const Text('退出登录'),
          ),
        ],
      ),
    ),
    );
  }
}