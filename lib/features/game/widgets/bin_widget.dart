// lib/features/game/widgets/bin_widget.dart

import 'package:flutter/material.dart';
import '../models/bin.dart';

class BinWidget extends StatelessWidget {
  final Bin bin;
  final void Function(String data) onAccept;

  const BinWidget({super.key, required this.bin, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (data) => true,
      onAccept: onAccept,
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedScale(
          scale: isHovered ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isHovered
                      ? [
                          BoxShadow(
                            color: bin.color.withOpacity(0.5),
                            blurRadius: 16,
                            spreadRadius: 3,
                          )
                        ]
                      : [],
                ),
                child: Image.asset(
                  bin.imagePath,
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                bin.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isHovered ? bin.color : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}