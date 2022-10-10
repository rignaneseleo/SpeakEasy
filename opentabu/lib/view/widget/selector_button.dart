import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:opentabu/theme/theme.dart';

class SelectorButton extends StatefulWidget {
  final List<String> items;
  final int indexSelected;
  final ValueChanged<int> onValueChanged;

  const SelectorButton(
      {Key? key,
      required this.items,
      required this.indexSelected,
      required this.onValueChanged})
      : super(key: key);

  @override
  _SelectorButtonState createState() => _SelectorButtonState(indexSelected);
}

class _SelectorButtonState extends State<SelectorButton> {
  int _selected;

  _SelectorButtonState(this._selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: new BoxDecoration(
        color: midPurple,
        borderRadius: new BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (String item in widget.items)
            Expanded(
              child: SelectionItem(
                text: item,
                highlighted: widget.items.indexOf(item) == _selected,
                onPressed: () {
                  int i = widget.items.indexOf(item);
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
  final String text;
  final bool highlighted;
  final bool disabled;
  final VoidCallback? onPressed;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressEndCallback? onLongPressEnd;

  SelectionItem({
    Key? key,
    required this.text,
    this.highlighted = false,
    this.onPressed,
    this.disabled = false,
    this.onLongPressStart,
    this.onLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1),
          height: 22,
          decoration: new BoxDecoration(
            color: highlighted ? darkPurple : Colors.transparent,
            borderRadius: new BorderRadius.all(
              const Radius.circular(6.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Center(
            child: AutoSizeText(
              text,
              maxFontSize:
                  Theme.of(context).textTheme.headline5?.fontSize ?? 20,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        onTap: onPressed,
        onLongPressStart: onLongPressStart,
        onLongPressEnd: onLongPressEnd,
      ),
    );
  }
}
