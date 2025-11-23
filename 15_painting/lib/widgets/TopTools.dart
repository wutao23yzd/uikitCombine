import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting/bloc/painting_bloc.dart';
import 'package:painting/services/save_as_image.dart';

class Toptools extends StatefulWidget {
  const Toptools({super.key, required this.contentKey});
  final GlobalKey contentKey;
  @override
  State<Toptools> createState() => _ToptoolsState();
}

class _ToptoolsState extends State<Toptools> {
  @override
  Widget build(BuildContext context) {

    final isEraserMode = context.select((PaintingBloc bloc) => bloc.state.isEraserMode);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context.read<PaintingBloc>().add(RemoveLastLineEvent());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2
                )
              ),
              child: Transform.scale(
                scale: 0.6,
                child: ImageIcon(
                  const AssetImage('assets/images/return.png'),
                  color: Colors.white
                ),
              ),
            ),
          ),

          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
            child: GestureDetector(
              onTap: () {
                context.read<PaintingBloc>().add(const RedoLastLineEvent());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Transform.scale(
                  scale: 0.6,
                  child: const ImageIcon(
                    AssetImage('assets/images/return.png'),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

    GestureDetector(
      onTap: () {
        context.read<PaintingBloc>().add(ToggleEraserModeEvent());
      },
      onLongPress: () {
        context.read<PaintingBloc>().add(const ClearAllEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("画布已清空"),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Transform.scale(
          scale: 0.6,
          child: Icon(
            Icons.cleaning_services,
            color: isEraserMode ? Colors.yellow : Colors.white,
          ),
        ),
      ),
    ),

    GestureDetector(
            onTap: () async {
              final paintingBloc = context.read<PaintingBloc>();
              final lines = paintingBloc.state.lines;

              if (lines.isNotEmpty) {
                final response = await takePicture(
                  contentKey: widget.contentKey,
                  context: context,
                  saveToGallery: true,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text( response != null ? '保存成功' : '保存失败'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white,
                      width: 2
                  )
              ),
              child: Transform.scale(
                scale: 0.6,
                child: ImageIcon(
                    const AssetImage('assets/images/check.png'),
                    color: Colors.white
                ),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
