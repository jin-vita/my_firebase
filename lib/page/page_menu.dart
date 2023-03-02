import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('menu page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${Get.arguments.id}'),
            Text('${Get.arguments.actionId}'),
            Text('${Get.arguments.input}'),
            Text('${Get.arguments.payload}'),
          ],
        ),
      ),
    );
  }
}
