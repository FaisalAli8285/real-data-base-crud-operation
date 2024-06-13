import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  String title;
 final bool loading;
  final VoidCallback onTap;
  RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child:widget.loading? CircularProgressIndicator(color: Colors.white,strokeWidth: 3,): Text(
              widget.title,
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
