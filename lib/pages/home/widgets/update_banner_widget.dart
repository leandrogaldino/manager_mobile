import 'package:flutter/material.dart';

class UpdateBannerWidget extends StatefulWidget {
  final Future<void> Function() onTap;

  const UpdateBannerWidget({
    super.key,
    required this.onTap,
  });

  @override
  State<UpdateBannerWidget> createState() => _UpdateBannerWidgetState();
}

class _UpdateBannerWidgetState extends State<UpdateBannerWidget> {
  bool _loading = false;

  Future<void> _handleTap() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      await widget.onTap();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.secondary,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _loading ? null : _handleTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _loading
                          ? SizedBox(
                              key: const ValueKey('loader'),
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  colorScheme.onSecondary,
                                ),
                              ),
                            )
                          : Text(
                              'Há alterações disponíveis',
                              key: const ValueKey('text'),
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                    ),
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
