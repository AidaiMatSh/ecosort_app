import 'package:flutter/material.dart';
import '../models/bin.dart';

class BinWidget extends StatelessWidget {
  final Bin bin;
  final Function(String) onAccept;

  const BinWidget({
    super.key,
    required this.bin,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAccept: (data) => onAccept(data),

      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.green.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              bin.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}