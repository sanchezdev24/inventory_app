import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Loading indicator variants
enum LoadingVariant { circular, linear, dots }

/// Loading indicator atom
class AppLoadingIndicator extends StatelessWidget {
  final LoadingVariant variant;
  final double? size;
  final Color? color;
  final double strokeWidth;

  const AppLoadingIndicator({
    super.key,
    this.variant = LoadingVariant.circular,
    this.size,
    this.color,
    this.strokeWidth = 3,
  });

  const AppLoadingIndicator.circular({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
  }) : variant = LoadingVariant.circular;

  const AppLoadingIndicator.small({
    super.key,
    this.color,
    this.strokeWidth = 2,
  })  : variant = LoadingVariant.circular,
        size = 20;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? AppColors.primary;

    switch (variant) {
      case LoadingVariant.circular:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation(indicatorColor),
          ),
        );
      case LoadingVariant.linear:
        return LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation(indicatorColor),
          backgroundColor: indicatorColor.withValues(alpha: 0.2),
        );
      case LoadingVariant.dots:
        return _DotsLoadingIndicator(color: indicatorColor, size: size ?? 40);
    }
  }
}

/// Animated dots loading indicator
class _DotsLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const _DotsLoadingIndicator({
    required this.color,
    required this.size,
  });

  @override
  State<_DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<_DotsLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 4;

    return SizedBox(
      width: widget.size,
      height: dotSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.15;
              final progress = (_controller.value - delay) % 1.0;
              final scale = 0.5 + 0.5 * (1 - (progress * 2 - 1).abs());
              final opacity = 0.3 + 0.7 * scale;

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Shimmer loading effect
class AppShimmer extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const AppShimmer({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AppShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.neutral200,
                AppColors.neutral100,
                AppColors.neutral200,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Skeleton loading placeholder
class AppSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  const AppSkeleton.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(999));

  const AppSkeleton.rectangle({
    super.key,
    this.width,
    required this.height,
  }) : borderRadius = AppSpacing.borderRadiusSm;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: borderRadius ?? AppSpacing.borderRadiusSm,
        ),
      ),
    );
  }
}