import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SelectorButton extends StatefulWidget {
  const SelectorButton({
    super.key,
    required this.items,
    required this.indexSelected,
    required this.onValueChanged,
  });

  final List<String> items;
  final int indexSelected;
  final ValueChanged<int> onValueChanged;

  @override
  State<SelectorButton> createState() => _SelectorButtonState();
}

class _SelectorButtonState extends State<SelectorButton> {
  late int _selected = widget.indexSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: AppColors.midPurple,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          for (int i = 0; i < widget.items.length; i++)
            Expanded(
              child: SelectionItem(
                text: widget.items[i],
                highlighted: i == _selected,
                onPressed: () {
                  setState(() {
                    _selected = i;
                    widget.onValueChanged(i);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class SelectionItem extends StatelessWidget {
  const SelectionItem({
    super.key,
    required this.text,
    this.highlighted = false,
    this.onPressed,
    this.disabled = false,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  final String text;
  final bool highlighted;
  final bool disabled;
  final VoidCallback? onPressed;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressEndCallback? onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: GestureDetector(
        onTap: onPressed,
        onLongPressStart: onLongPressStart,
        onLongPressEnd: onLongPressEnd,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          height: 22,
          decoration: BoxDecoration(
            color: highlighted ? AppColors.darkPurple : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Center(
            child: AutoSizeText(
              text,
              maxFontSize:
                  Theme.of(context).textTheme.headlineSmall?.fontSize ?? 20,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}
