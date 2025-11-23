import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting/bloc/painting_bloc.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({super.key});

  @override
  Widget build(BuildContext context) {

    final colorList = context.select((PaintingBloc bloc) => bloc.colorList);
    final lineColorIndex = context.select((PaintingBloc bloc) => bloc.state.lineColorIndex);

    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.width * 0.1,
      width: screenSize.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorList[lineColorIndex],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5)
            ),
            child: ImageIcon(
              const AssetImage('assets/images/pickColor.png'),
              color: lineColorIndex == 0 ? Colors.black : Colors.white,
              size: 20,
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...colorList.map((color) {
                    final int index = colorList.indexOf(color);
                    return GestureDetector(
                      onTap: () {
                        context.read<PaintingBloc>().add(UpdateLineColorIndexEvent(index));
                      },
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorList[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5
                            )
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
