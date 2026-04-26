import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../widgets/profile_avatar.dart';

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

    firstNameController =
        TextEditingController(text: widget.user.firstName);
    lastNameController =
        TextEditingController(text: widget.user.lastName);
    emailController =
        TextEditingController(text: widget.user.email);
    addressController =
        TextEditingController(text: widget.user.address);

    birthDate = widget.user.birthDate;
    avatarPath = widget.user.avatarPath;
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        avatarPath = picked.path;
      });
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        birthDate = date;
      });
    }
  }

  void save() {
    final updatedUser = UserModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      address: addressController.text,
      birthDate: birthDate,
      avatarPath: avatarPath,
    );

    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактировать"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileAvatar(
              imagePath: avatarPath,
              onTap: pickImage,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "Имя"),
            ),

            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Фамилия"),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Адрес"),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Text(
                  birthDate == null
                      ? "Дата рождения не выбрана"
                      : birthDate.toString().split(" ")[0],
                ),
                const Spacer(),
                TextButton(
                  onPressed: pickDate,
                  child: const Text("Выбрать"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: const Text("Сохранить"),
            ),
          ],
        ),
      ),
    );
  }
}