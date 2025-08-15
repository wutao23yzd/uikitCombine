import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_views/packages/app_ui/app_theme.dart';
import 'package:reel_views/reels/bloc/reel_bloc.dart';
import 'package:reel_views/reels/reel/view/reel_view.dart';

class ReelsView extends StatefulWidget {
  const ReelsView({super.key});

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: false);
    _currentIndex = ValueNotifier(0);
 
    context.read<ReelBloc>().add(const ReelRecommendedPostsPageRequested());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: BlocBuilder<ReelBloc, ReelState>(
            builder: (context, state) {
              final blocks = state.blocks;
                    
              return PageView.builder(
                controller: _pageController,
                itemCount: blocks.length,
                allowImplicitScrolling: true,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                onPageChanged: (index) => _currentIndex.value = index,
                itemBuilder: (context, index) {

                  return ListenableBuilder(
                    listenable: _currentIndex, 
                    builder: (context, _) {
                      final isCurrent = index == _currentIndex.value;
                      final block = blocks[index];
                
                      return Reel(
                        key: ValueKey(block.id),
                        play: isCurrent,
                        block: block,
                      );
                    }
                  );
                },
              );
            },
          ),
        ).withAdaptiveSystemTheme(context),
      ],
    );
  }
}
