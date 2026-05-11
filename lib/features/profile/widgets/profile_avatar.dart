import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundImage:
            imagePath != null ? FileImage(File(imagePath!)) : null,
        child: imagePath == null
            ? const Icon(Icons.person, size: 50)
            : null,
      ),
    );
  }
}