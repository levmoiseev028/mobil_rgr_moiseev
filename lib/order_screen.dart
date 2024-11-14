import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rgr_proj/purchase.dart';
import 'package:rgr_proj/order.dart';
import 'package:rgr_proj/add_order_screen.dart';
import 'package:rgr_proj/edit_order_screen.dart';
import 'package:rgr_proj/login_screen.dart';
import 'package:rgr_proj/home_screen.dart';

class OrderScreen extends StatefulWidget {
  final Purchase purchase;

  OrderScreen({required this.purchase});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orders = [];

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь не авторизован')),
      );
      return;
    }

    setState(() {
      orders = [
        Order(
          id: '1',
          title: 'Заказ 1',
          description: 'Описание заказа 1',
          purchaseId: widget.purchase.id,
          option: 'Нет',
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _addOrder() async {
    final newOrder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrderScreen(purchase: widget.purchase),
      ),
    );

    if (newOrder != null) {
      setState(() {
        orders.add(newOrder);
      });
    }
  }

  void _editOrder(Order order) async {
    final updatedOrder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrderScreen(
          order: order,
          onOrderUpdated: (updatedOrder) {
            setState(() {
              final index = orders.indexWhere((o) => o.id == updatedOrder.id);
              if (index != -1) {
                orders[index] = updatedOrder;
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteOrder(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить этот заказ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                orders.removeWhere((o) => o.id == order.id);
              });
              Navigator.of(context).pop();
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Вы уверены, что хотите выйти из аккаунта?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Да'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _confirmPurchase() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Покупка оформлена')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заказы покупки: ${widget.purchase.title}'),
        actions: [],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text(order.title),
                subtitle: Text('Надгробная плита: ${order.option}\n${order.description}'),
                onTap: () => _editOrder(order),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteOrder(order),
                  tooltip: 'Удалить заказ',
                ),
              );
            },
          ),
          Positioned(
            bottom: 18,
            left: 18,
            child: FloatingActionButton(
              onPressed: _logout,
              child: Icon(Icons.exit_to_app),
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              tooltip: 'Выйти из аккаунта',
            ),
          ),
          Positioned(
            bottom: 16,
            left: MediaQuery.of(context).size.width / 2 - 80,
            child: ElevatedButton(
              onPressed: _confirmPurchase,
              child: Text('Оформить покупку'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrder,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        tooltip: 'Добавить заказ',
      ),
    );
  }
}
