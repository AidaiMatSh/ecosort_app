import 'package:flutter/material.dart';

class UserProfile {
  String firstName;
  String lastName;
  String city;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.city,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile profile = UserProfile(
    firstName: 'Иван',
    lastName: 'Иванов',
    city: 'Бишкек',
  );

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(profile: profile),
      ),
    );

    if (result != null) {
      setState(() {
        profile = result;
      });

      // 📍 здесь потом будет обновление карты
      print("Новый город: ${profile.city}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя: ${profile.firstName}', style: const TextStyle(fontSize: 18)),
            Text('Фамилия: ${profile.lastName}', style: const TextStyle(fontSize: 18)),
            Text('Город: ${profile.city}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _editProfile,
              child: const Text('Редактировать профиль'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController cityController;

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController(text: widget.profile.firstName);
    lastNameController =
        TextEditingController(text: widget.profile.lastName);
    cityController =
        TextEditingController(text: widget.profile.city);
  }

  void _save() {
    final updated = UserProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      city: cityController.text,
    );

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактирование')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Фамилия'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'Город'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _save,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
