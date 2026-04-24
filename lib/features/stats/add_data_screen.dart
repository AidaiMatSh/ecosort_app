import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/waste_entry.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = "Пластик";

  final List<String> categories = [
    "Пластик",
    "Стекло",
    "Бумага",
    "Металл",
    "Органика",
    "Смешанные отходы",
  ];

  Future<void> saveData() async {
    final text = _amountController.text.trim().replaceAll(',', '.');
    final double? value = double.tryParse(text);

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Введите корректное количество в кг"),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList("waste_data") ?? [];

    final entry = WasteEntry(
      category: _selectedCategory,
      amount: value,
      date: DateTime.now(),
    );

    data.add(jsonEncode(entry.toJson()));
    await prefs.setStringList("waste_data", data);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавить данные")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Категория",
                border: OutlineInputBorder(),
              ),
              items: categories.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Количество (кг)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveData,
                child: const Text("Сохранить"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
