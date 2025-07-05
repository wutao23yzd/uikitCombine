
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_instagram_clone_app/auth/login/model/user.dart';

class AuthRepository {
  AuthRepository();

  /// 当前用户流：User.empty 代表未登录
  Stream<User> get user => _controller.stream;
  final _controller = StreamController<User>.broadcast()
    ..add(User.empty);

  /// 登录成功后向流里 add(User)
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // TODO: 调真实接口，捕获错误抛出自定义异常
    await Future.delayed(const Duration(seconds: 2));

    // 这里简单用 email+password 构造一个 User
    _controller.add(
      User(id: 'mock_id', email: email, password: password),
    );
  }

  /// 登出
  Future<void> logout() async {
    // 如有服务器登出接口，在此调用
    _controller.add(User.empty);
  }

  @visibleForTesting
  void dispose() => _controller.close();
}
