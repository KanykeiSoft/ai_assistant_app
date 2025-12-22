import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.variant,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2F6B4F);

    final isPrimary = widget.variant == AppButtonVariant.primary;

    final bgColor = _pressed
        ? green
        : (isPrimary ? green : Colors.white);

    final textColor = _pressed
        ? Colors.white
        : (isPrimary ? Colors.white : green);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: green,
            width: isPrimary ? 0 : 1.6,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 10),
              color: Color(0x12000000),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }
}



