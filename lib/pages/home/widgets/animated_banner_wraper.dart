import 'package:flutter/material.dart';

class AnimatedBannerWrapper extends StatefulWidget {
  final bool visible;
  final Widget child;

  const AnimatedBannerWrapper({
    super.key,
    required this.visible,
    required this.child,
  });

  @override
  State<AnimatedBannerWrapper> createState() => _AnimatedBannerWrapperState();
}

class _AnimatedBannerWrapperState extends State<AnimatedBannerWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBannerWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.visible && !oldWidget.visible) {
      _controller.forward();
    } else if (!widget.visible && oldWidget.visible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: widget.visible
            ? SlideTransition(
                position: _slide,
                child: widget.child,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
