import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orbitpatter/core/utils/flushbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppBar(title: Center(child: const Text('Home Screen'))),
      body: Center(child: Text('Orbit Patter')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to perform when the button is pressed
          print('Floating Action Button Pressed');
          OrbitFlushbar.success(context, "Data saved successfully!");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
