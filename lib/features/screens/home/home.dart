import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/core/utils/flushbar.dart';
import 'package:orbitpatter/features/blocs/location/location_bloc.dart';
import 'package:orbitpatter/features/blocs/location/location_event.dart';
import 'package:orbitpatter/features/blocs/location/location_state.dart';
import 'package:orbitpatter/features/screens/home/widgets/flutter_map.dart';

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

    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to another screen or perform another action
      context.read<LocationBloc>().add(FetchLocationEvent());
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
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  if (state is LocationLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is LocationLoaded) {
                    final loc = state.location as Map<String, double>;
                    return CustomMap(
                      markerCoordinates: [
                        [loc['latitude']!, loc['longitude']!],
                      ],
                      zoomLevel: 12.0,
                      initialCenter: [loc['latitude']!, loc['longitude']!],
                    );
                  } else if (state is LocationError) {
                    return Center(
                      child: Text('Error: ${state.message}'),
                    );
                  }
                  return const Center(
                    child: Text('Press the button to fetch location'),
                  );
                }
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
