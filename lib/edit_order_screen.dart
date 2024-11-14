import 'package:flutter/material.dart';
import 'package:rgr_proj/order.dart';

class EditOrderScreen extends StatefulWidget {
  final Order order; //
  final Function(Order) onOrderUpdated;

  EditOrderScreen({required this.order, required this.onOrderUpdated});

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  String selectedOption = '';

  List<String> options = ['Нет', 'Мрамор', 'Гранит'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.order.title);
    _descriptionController = TextEditingController(text: widget.order.description);
    selectedOption = widget.order.option;
  }

  void _updateOrder() {
    final updatedOrder = Order(
      id: widget.order.id,
      purchaseId: widget.order.purchaseId,
      title: _titleController.text,
      description: _descriptionController.text,
      option: selectedOption,
    );

    widget.onOrderUpdated(updatedOrder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать заказ')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Заголовок заказа'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание заказа'),
            ),
            SizedBox(height: 16),
            Text('Выберите опцию:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
              isExpanded: true,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 18),
            ElevatedButton(
              onPressed: _updateOrder,
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
