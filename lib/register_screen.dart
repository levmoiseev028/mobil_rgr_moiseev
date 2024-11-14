import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  Future<void> _registerUser(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.length < 3) {
      _showErrorDialog(context, 'Логин должен содержать хотя бы 3 символа.');
      return;
    }

    if (password.length < 3) {
      _showErrorDialog(context, 'Пароль должен содержать хотя бы 3 символа.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final userId = DateTime.now().millisecondsSinceEpoch.toString();

    await prefs.setString('userId', userId);
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
            ),
            ElevatedButton(
              onPressed: () => _registerUser(context),
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
