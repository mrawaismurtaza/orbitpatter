import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/core/services/hive_service.dart';
import 'package:orbitpatter/core/utils/flushbar.dart';
import 'package:orbitpatter/data/repositories/open_trip_map_repo.dart';
import 'package:orbitpatter/features/blocs/location/location_bloc.dart';
import 'package:orbitpatter/features/blocs/location/location_event.dart';
import 'package:orbitpatter/features/blocs/location/location_state.dart';
import 'package:orbitpatter/features/screens/home/widgets/catogory_filters.dart';
import 'package:orbitpatter/features/screens/home/widgets/flutter_map.dart';
import 'package:orbitpatter/main.dart';
import 'package:redacted/redacted.dart';

class Home extends StatefulWidget {
  final Object? extra;
  const Home({super.key, this.extra});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedCategory;
  final List<String> categories = [
    '🍽️ Food',
    '🛍️ Shopping',
    '🎭 Culture',
    '📸 Sights',
    '🕌 Religion',
    '🌳 Nature',
  ];

  @override
  void initState() {
    super.initState();

    selectedCategory = categories.first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = widget.extra as Map<String, dynamic>?;
      if (extra?['showLoginSuccess'] == true) {
        OrbitFlushbar.success(
          context,
          'Login successful! ${extra?['userName'] ?? ''}',
        );
      }
    });

    // OpenTripMapRepo().fetchPlaces(73.0551, 33.6844, "shops");

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.read<LocationBloc>().add(FetchLocationEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          bottom: 20.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: 48,
              child: CategoryFilters(
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                  print('Selected category: $category');
                  // You can also update the state or perform other actions here
                },
                categories: categories,
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 10,
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  if (state is LocationLoading) {
                    return Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const SizedBox.expand().redacted(
                            context: context,
                            redact: true,
                          ),
                        ),
                      ),
                    );
                  } else if (state is LocationLoaded) {
                    getIt<HiveService>().cacheLocation(state.location);
                    final loc = state.location;
                    return CustomMap(
                      markerCoordinates: [
                        [loc.latitude, loc.longitude],
                      ],
                      zoomLevel: 12.0,
                      initialCenter: [loc.latitude, loc.longitude],
                    );
                  } else if (state is LocationError) {
                    return FutureBuilder(
                      future: getIt<HiveService>().getCachedLocation(),
                      builder: (contxt, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final cachedLocation = snapshot.data!;
                          return CustomMap(
                            markerCoordinates: [
                              [
                                cachedLocation.latitude,
                                cachedLocation.longitude,
                              ],
                            ],
                            zoomLevel: 12.0,
                            initialCenter: [
                              cachedLocation.latitude,
                              cachedLocation.longitude,
                            ],
                          );
                        } else {
                          return const Center(
                            child: Text('No cached location available'),
                          );
                        }
                      },
                    );
                  }
                  return const Center(
                    child: Text('Press the button to fetch location'),
                  );
                },
              ),
            ),
            Spacer(),
            Expanded(
              flex: 20,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 400,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
