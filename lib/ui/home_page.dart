import 'package:uts_mobile/ui/side_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const SideMenu(),
      body: const Center(child: Text('Selamat datang ^_^')),
    );
  }
}
