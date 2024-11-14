import 'package:flutter/material.dart';
import 'package:rgr_proj/purchase.dart';
import 'package:rgr_proj/order.dart';

class AddOrderScreen extends StatefulWidget {
  final Purchase purchase;

  AddOrderScreen({required this.purchase});

  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String selectedOption = 'Нет';
  List<String> options = ['Нет', 'Мрамор', 'Гранит'];

  void _saveOrder() {
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      purchaseId: widget.purchase.id,
      title: _titleController.text,
      description: _descriptionController.text,
      option: selectedOption,
    );

    Navigator.pop(context, newOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить заказ')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Заголовок заказа'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание заказа'),
            ),
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _saveOrder,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
