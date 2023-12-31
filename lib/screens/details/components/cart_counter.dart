import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'rounded_icon_btn.dart';

class CartCounter extends StatefulWidget {
  const CartCounter({
    Key? key,
    int? value,
    required this.onValueChanged, // New callback for value changes
  }) : super(key: key);

  final ValueChanged<int> onValueChanged; // Callback for value changes

  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int value = 1;

  void increment() {
    setState(() {
      value++;
      widget.onValueChanged(value); // Call the callback with the updated value
    });
  }

  void decrement() {
    setState(() {
      if (value > 1) {
        value--;
        widget
            .onValueChanged(value); // Call the callback with the updated value
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        children: [
          RoundIconBtn(
            iconData: Icons.remove,
            color: Colors.black38,
            press: decrement,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 4),
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
          RoundIconBtn(
            iconData: Icons.add,
            press: increment,
          ),
        ],
      ),
    );
  }
}
