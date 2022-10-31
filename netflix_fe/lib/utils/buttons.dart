import 'package:flutter/material.dart';

// const kTurquoise = Color(0xff58C5CC);
const kTurquoise = Colors.blue;

class ButtonType1 extends StatelessWidget {
  final VoidCallback onPress;
  final Color colour;
  final String text;

  const ButtonType1(
      {super.key,
      required this.onPress,
      required this.text,
      this.colour = kTurquoise});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 4.0,
      onPressed: onPress,
      fillColor: colour,
      constraints: const BoxConstraints(minWidth: 150.0, minHeight: 40.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  final String value;
  final List<String> items;
  final void Function(String?) onPress;
  const DropDown(
      {super.key,
      required this.items,
      required this.onPress,
      required this.value});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      // Initial Value
      value: widget.value,
      hint: const Text(
        '--none--',
        style: TextStyle(color: Colors.grey, fontSize: 15),
      ),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: widget.items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: widget.onPress,
    );
  }
}

class NumberTextField extends StatefulWidget {
  final String text;
  final void Function(String?) onChange;
  final double height;

  const NumberTextField(
      {super.key, this.text = '', required this.onChange, this.height = 45});
  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: SizedBox(
        height: widget.height,
        width: 100,
        child: TextField(
          onChanged: widget.onChange,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100]!.withOpacity(0.5),
            contentPadding: const EdgeInsets.only(left: 14, bottom: 8, top: 8),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kTurquoise, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kTurquoise, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.text,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
