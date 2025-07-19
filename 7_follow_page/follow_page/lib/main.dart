import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:follow_page/follow/bloc/bloc/user_profile_bloc.dart';
import 'package:follow_page/follow/view/user_profile_statistics.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: BlocProvider(
        create: (context) => UserProfileBloc(),
        child: UserProfileStatistics(tabIndex: 0),
      ),
    );
  }
}
