import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/core/utils/flushbar.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/features/blocs/auth/login_event.dart';
import 'package:orbitpatter/features/blocs/auth/login_state.dart';
import 'package:orbitpatter/features/screens/home/widgets/flutter_map.dart';
import 'package:orbitpatter/features/shared_widgets/button.dart';

class Home extends StatefulWidget {
  final Object? extra;
  const Home({super.key, this.extra});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = widget.extra as Map<String, dynamic>?;
      if (extra?['showLoginSuccess'] == true) {
        OrbitFlushbar.success(
          context,
          'Login successful! ${extra?['userName'] ?? ''}',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
        child: Flex(
        
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 2,
              child: CustomMap(
                markerCoordinates: [
                  [37.7749, -122.4194], // Example coordinates (San Francisco)
                  [34.0522, -118.2437], // Example coordinates (Los Angeles)
                ],
                zoomLevel: 5.0,
                initialCenter: [34.0522, -118.2437], // Example initial center (California)
              ),
            ),
            Spacer(),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
