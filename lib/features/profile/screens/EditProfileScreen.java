// ✅ КУДА: lib/features/profile/screens/edit_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  DateTime? birthDate;
  String? avatarPath;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    emailController = TextEditingController(text: widget.user.email);
    addressController = TextEditingController(text: widget.user.address);
    birthDate = widget.user.birthDate;
    avatarPath = widget.user.avatarPath;
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => avatarPath = picked.path);
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green.shade700),
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => birthDate = date);
  }

  void save() {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заполните имя и фамилию")),
      );
      return;
    }
    final updatedUser = UserModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      birthDate: birthDate,
      avatarPath: avatarPath,
    );
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text("Редактировать профиль"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: save,
            child: const Text("Сохранить",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Аватар
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green.shade300, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.green.shade100,
                      backgroundImage:
                          avatarPath != null ? FileImage(File(avatarPath!)) : null,
                      child: avatarPath == null
                          ? Icon(Icons.person, size: 55, color: Colors.green.shade400)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text("Нажмите чтобы изменить фото",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),

            const SizedBox(height: 28),

            _buildField(
              controller: firstNameController,
              label: "Имя",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: lastNameController,
              label: "Фамилия",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: emailController,
              label: "Email",
              icon: Icons.email_outlined,
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: addressController,
              label: "Адрес",
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 12),

            // Дата рождения
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.green.shade100, width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cake_outlined, color: Colors.green.shade700, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Дата рождения",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          const SizedBox(height: 2),
                          Text(
                            birthDate != null
                                ? "${birthDate!.day}.${birthDate!.month}.${birthDate!.year}"
                                : "Не указана",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: birthDate != null
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: const Text("Сохранить",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade100, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green.shade700),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}