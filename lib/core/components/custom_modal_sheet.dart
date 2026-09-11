import 'package:flutter/material.dart';

class CustomModalSheetWidget extends StatelessWidget {
  final Widget child;
  final Widget? bottomChild;
  final double size;
  final double? maxSize;
  final Function()? onCompleted;
  final bool showClose;
  const CustomModalSheetWidget({
    super.key,
    required this.child,
    this.bottomChild,
    required this.size,
    this.maxSize,
    this.onCompleted,
    this.showClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (builder, constraints) {
        return Stack(
          alignment: .center,
          clipBehavior: .none,
          children: [
            DraggableScrollableSheet(
              initialChildSize: size,
              maxChildSize: maxSize ?? 0.8,
              minChildSize: 0,
              expand: false,
              snap: true,
              snapSizes: [0 / constraints.maxHeight, size],
              builder: (context, scrollController) {
                return CustomScrollView(
                  shrinkWrap: true,
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: child),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: bottomChild,
                      ),
                    ),
                  ],
                );
              },
            ),
            if (showClose) Positioned(top: -110, child: CloseButton()),
          ],
        );
      },
    );
  }
}
