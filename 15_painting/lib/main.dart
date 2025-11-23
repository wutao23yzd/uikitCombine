import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting/bloc/painting_bloc.dart';
import 'package:painting/widgets/TopTools.dart';
import 'package:painting/widgets/color_selector.dart';
import 'package:painting/widgets/size_slider_selector.dart';
import 'package:painting/widgets/sketcher.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black
        )
      ),
      home: BlocProvider(
        create: (context) => PaintingBloc(),
        child: Painting(),
      )
    );
  }
}

class Painting extends StatefulWidget {
  const Painting({super.key});

  @override
  State<StatefulWidget> createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  final GlobalKey canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;

    final canvasHeight = Platform.isIOS
        ? (size.height - 132) - paddingTop
        : size.height - 132;

    Offset? _getLocalOffset(Offset global) {
      final ctx = canvasKey.currentContext;
      if (ctx == null) return null;
      final box = ctx.findRenderObject() as RenderBox;
      return box.globalToLocal(global);
    }

    void handlePanStart(DragStartDetails details) {
      final local = _getLocalOffset(details.globalPosition);
      if (local == null) return;

      if (local.dy < 6) {
        return;
      }

      context
          .read<PaintingBloc>()
          .add(PanStartEvent(PointVector(local.dx, local.dy)));
    }

    void handlePanUpdate(DragUpdateDetails details) {

      final local = _getLocalOffset(details.globalPosition);
      if (local == null) return;

      context
          .read<PaintingBloc>()
          .add(PanUpdateEvent(PointVector(local.dx, local.dy)));
    }

    void handlePanEnd(DragEndDetails details) {
      context.read<PaintingBloc>().add(PanEndEvent());
    }

    Widget renderCanvas() {
      return GestureDetector(
        onPanStart: handlePanStart,
        onPanUpdate: handlePanUpdate,
        onPanEnd: handlePanEnd,
        child: RepaintBoundary(
          key: canvasKey,
          child: Container(
            width: size.width,
            height: canvasHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 78, 173, 195),
                  const Color.fromARGB(125, 78, 173, 195),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BlocBuilder<PaintingBloc, PaintingState>(
              builder: (context, state) {
                return CustomPaint(
                  painter: Sketcher(
                    lines: [
                      ...state.lines,
                      if (state.currentLine != null) state.currentLine!,
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: size.width,
            height: canvasHeight,
            child: Stack(
              children: [
                renderCanvas(),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: SizeSliderWidget(),
                  ),
                ),

                Toptools(contentKey: canvasKey),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: const ColorSelector(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


