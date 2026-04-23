import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  ];

 Future<void> saveData() async {
   final prefs = await SharedPreferences.getInstance();

   double value = double.tryParse(_amountController.text) ?? 0;

   if (value <= 0) return; // защита от пустого ввода

   List<String> data = prefs.getStringList("waste_data") ?? [];

   WasteEntry entry = WasteEntry(
     category: _selectedCategory,
     amount: value,
     date: DateTime.now(),
   );

   data.add(jsonEncode(entry.toJson()));

   await prefs.setStringList("waste_data", data);

   Navigator.pop(context);
 }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавить данные")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
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
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Количество (кг)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveData,
              child: const Text("Сохранить"),
            ),
          ],
        ),
      ),
    );
  }
}
